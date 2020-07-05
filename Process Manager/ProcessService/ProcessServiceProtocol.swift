//
//  ProcessServiceProtocol.h
//  ProcessService
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

@objc(ProcessServiceProtocol)
public protocol ProcessServiceProtocol {
    func killProcessWithId(_ pid: pid_t, replyBlock: @escaping (Int32) -> ())
    func killPrivilegedProcessWithId(_ pid: pid_t, replyBlock: @escaping (String) -> ())
}
