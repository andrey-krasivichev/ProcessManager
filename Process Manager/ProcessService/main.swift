//
//  main.m
//  ProcessService
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

let delegate = ProcessServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
