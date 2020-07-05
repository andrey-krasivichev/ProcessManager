//
//  Utils.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation
import Cocoa

typealias VoidBlock = () -> Void
typealias StringBlock = (String) -> Void
typealias IntResultBlock = () -> Int

func RedispatchToMain(_ block: @escaping VoidBlock) {
    if Thread.current.isMainThread {
        block()
        return
    }
    DispatchQueue.main.async(execute: block)
}

func RedispatchToBackground(_ block: @escaping VoidBlock) {
    if !Thread.current.isMainThread {
        block()
        return
    }
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: block)
}

extension NSView {
    func setContentPriorityRequired() {
        self.setContentHuggingPriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.horizontal)
        self.setContentHuggingPriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.vertical)
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.vertical)
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.horizontal)
    }
}
