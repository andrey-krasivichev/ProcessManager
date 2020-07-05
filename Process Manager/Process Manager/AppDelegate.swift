//
//  AppDelegate.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 26.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var activeBlock: VoidBlock = { }
    var inactiveBlock: VoidBlock = {}

    func applicationWillResignActive(_ notification: Notification) {
        self.inactiveBlock()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        self.activeBlock()
    }
}

