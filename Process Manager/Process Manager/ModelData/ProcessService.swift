//
//  ProcessService.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

class ProcessService: ProcessServiceProtocol {
    private var remoteObject: ProcessServiceProtocol?
    
    init() {
        self.connect()
    }
    
    func connect() {
        let connection = NSXPCConnection(serviceName: "com.krasivichev.andrey.ProcessService")
        connection.remoteObjectInterface = NSXPCInterface(with: ProcessServiceProtocol.self)
        connection.resume()
        
        let service = connection.remoteObjectProxyWithErrorHandler { (error) in
            print(">> error \(error)")
        } as? ProcessServiceProtocol
        self.remoteObject = service
    }
    
    // MARK: <ProcessServiceProtocol>
    func killProcessWithId(_ pid: pid_t, replyBlock: @escaping (Int32) -> ()) {
        if self.remoteObject == nil {
            self.connect()
        }
        self.remoteObject?.killProcessWithId(pid, replyBlock: replyBlock)
    }
    
    func killPrivilegedProcessWithId(_ pid: pid_t, replyBlock: @escaping (String) -> ()) {
        if self.remoteObject == nil {
            self.connect()
        }
        self.remoteObject?.killPrivilegedProcessWithId(pid, replyBlock: replyBlock)
    }
}
