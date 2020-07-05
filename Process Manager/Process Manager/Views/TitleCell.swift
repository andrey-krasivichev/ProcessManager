//
//  TitleCell.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 01.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

class TitleCell: NSTableCellView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.installTextField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func installTextField() {
        let field = NSTextField(frame: self.frame)
        self.addSubview(field)
        self.textField = field
        field.makeConstraints { (make) in
            make.edges.equalToSuperView()
        }
        field.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.horizontal)
        field.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.vertical)
        field.drawsBackground = false
        field.isEditable = false
        field.isBezeled = false
        field.backgroundColor = NSColor.clear
    }
}
