//
//  ProcessItemsFetcher.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 01.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

class ProcessItemsFetcher {
    var filterUserId: uid_t?
    var itemsFetchedBlock: ([String : ProcessItem]) -> Void = {_ in }
    var refetchInterval: TimeInterval = 2.0
    
    func startFetchEvents() {
        guard !self.fetchEnabled else {
            return
        }
        self.fetchEnabled = true
    }
    
    func finishFetchEvents() {
        self.fetchEnabled = false
    }
    
    private var fetchEnabled = false {
        didSet {
            self.schedulePollTimer()
        }
    }
    
    private func schedulePollTimer() {
        guard self.fetchEnabled else {
            return
        }
        let timer = Timer(timeInterval: self.refetchInterval, target: self, selector: #selector(fetchProcessesInBackground(_:)), userInfo: nil,
                          repeats: false)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    private func fetchProcesses() {
        let processInfoSize = MemoryLayout<kinfo_proc>.stride
        let processInfoAlignment = MemoryLayout<kinfo_proc>.alignment
        var error: Int32 = 0
        var length: Int = MemoryLayout<kinfo_proc>.size
        var name: [Int32] = [ CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 ]
        let nameSize: UInt32 = 4
        
        
        length = 0
        error = sysctl(&name, nameSize, nil, &length, nil, 0)
        
        guard error == 0 else {
            print(">> error occurred \(error)")
            self.fetchFinishedWithItemsById([:])
            return
        }
        
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: length, alignment: processInfoAlignment)
        defer {
            rawPointer.deallocate()
        }
        
        error = sysctl(&name, nameSize, rawPointer, &length, nil, 0)
        
        let allProcessesCount = length / processInfoSize
        let typedPointer = rawPointer.bindMemory(to: kinfo_proc.self, capacity: allProcessesCount)

        let procInfoBufferPointer = UnsafeBufferPointer(start: typedPointer, count: allProcessesCount)
        var processesById: [String : ProcessItem] = [:]
        for (_, value) in procInfoBufferPointer.enumerated() {
            
            let userId = value.kp_eproc.e_ucred.cr_uid
            var shouldAdd = self.filterUserId == nil
            if let filterId = self.filterUserId {
                shouldAdd = filterId == userId
            }
            var ownerName = ""
            if let userName = getpwuid(userId).pointee.pw_name {
                ownerName = String(utf8String: userName) ?? ownerName
            }

            if shouldAdd {
                let name = NSString.nameForProcess(withPID: value.kp_proc.p_pid) ?? value.processName()
                let nextItem = ProcessItem(identifier: "\(value.kp_proc.p_pid)", name: name, owner: ownerName)
                processesById[nextItem.identifier] = nextItem
            }
        }
        self.fetchFinishedWithItemsById(processesById)
    }

    @objc
    private func fetchProcessesInBackground(_ timer: Timer) {
        RedispatchToBackground {
            self.fetchProcesses()
        }
    }
    
    private func fetchFinishedWithItemsById(_ items: [String : ProcessItem]) {
        DispatchQueue.main.async {
            self.itemsFetchedBlock(items)
            self.schedulePollTimer()
        }
    }
}

private extension Int8 {
    func asUInt8() -> UInt8 {
        return UInt8(self)
    }
}

private extension kinfo_proc {
    func processName() -> String {
        // check size and get in more appropriatley
        let nameScalar = self.kp_proc.p_comm
        let bytes = [
            nameScalar.0.asUInt8(), nameScalar.1.asUInt8(), nameScalar.3.asUInt8(),
            nameScalar.3.asUInt8(), nameScalar.4.asUInt8(), nameScalar.5.asUInt8(),
            nameScalar.6.asUInt8(), nameScalar.7.asUInt8(), nameScalar.8.asUInt8(),
            nameScalar.9.asUInt8(), nameScalar.10.asUInt8(), nameScalar.11.asUInt8(),
            nameScalar.12.asUInt8(), nameScalar.13.asUInt8(), nameScalar.14.asUInt8(),
            nameScalar.15.asUInt8(), nameScalar.16.asUInt8()
        ]
        var name = String(bytes: bytes, encoding: String.Encoding.utf8) ?? "empty"
        name = name.replacingOccurrences(of: "\0", with: "")
        return name
    }
}
