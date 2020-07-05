//
//  ProcessService.h
//  ProcessService
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

class ProcessServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        
        newConnection.exportedInterface = NSXPCInterface(with: ProcessServiceProtocol.self)
        newConnection.exportedObject = ProcessService()
        newConnection.resume()
        
        return true
    }
}
