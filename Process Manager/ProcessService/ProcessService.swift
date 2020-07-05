//
//  ProcessService.m
//  ProcessService
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation
import ServiceManagement

class ProcessService: NSObject, ProcessServiceProtocol {
    lazy var authorization: Authorization = Authorization()
    
    func killProcessWithId(_ pid: pid_t, replyBlock: @escaping (Int32) -> ()) {
        let killSignal: Int32 = SIGKILL
        let result = kill(pid, killSignal)
        replyBlock(result)
    }
    
    func killPrivilegedProcessWithId(_ pid: pid_t, replyBlock: @escaping (String) -> ()) {
        self.authorization.killProcess(withId: pid, reply: replyBlock)
    }
}
