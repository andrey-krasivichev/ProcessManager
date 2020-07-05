//
//  PrivilegedHelper.swift
//  ProcessService
//
//  Created by Andrey Krasivichev on 04.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

class PrivilegedHelper: NSObject, PrivilegedHelperProtocol, NSXPCListenerDelegate {
    
    static let machServiceName = "com.krasivichev.andrey.PrivilegedHelper"
    private var listener: NSXPCListener
    
    override init() {
        self.listener = NSXPCListener(machServiceName: PrivilegedHelper.machServiceName)
        super.init()
        self.listener.delegate = self
    }
    
    func run() {
        self.listener.resume()
        RunLoop.current.run()
    }
    
    // MARK: <PrivilegedHelperProtocol>
    func getVersionWithReply(_ reply: (String) -> Void) {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            reply("unable to check")
            return
        }
        reply(version)
    }
    
    func killProcess(withId pid: pid_t, reply: (String) -> Void) {
        let result = kill(pid, SIGKILL)
        let answer = result == 0 ? "Kill confirmed" : "\(result)"
        reply(answer)
    }
    
    // MARK: <NSXPCListenerDelegate>
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: PrivilegedHelperProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
    }
}
