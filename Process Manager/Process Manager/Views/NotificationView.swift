//
//  NotificationView.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 04.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

extension NSTextField {
    static func notificationWithMessage(_ message: String) -> NSTextField {
        let notification = NSTextField()
        notification.alignment = NSTextAlignment.center
        notification.textColor = NSColor.white
        notification.wantsLayer = true
        notification.alphaValue = 0.0
        notification.isBezeled = false
        notification.isEditable = false
        notification.drawsBackground = false
        notification.layer?.masksToBounds = false
        notification.layer?.cornerRadius = 4.0
        notification.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
        notification.stringValue = message
        notification.setContentPriorityRequired()
        return notification
    }
}
