//
//  TableViewDelegateHandlerDefault.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 29.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

class TableViewDelegateHandlerDefault: NSObject, NSTableViewDelegate {
    private let cellReuseId = NSUserInterfaceItemIdentifier(rawValue: "TitleCell")
    let itemsContainer: IdentifiableItemsContainer
    let itemSelectedBlock: (ProcessItem?) -> Void
    
    init(container: IdentifiableItemsContainer, selectBlock: @escaping (ProcessItem?) -> Void) {
        self.itemsContainer = container
        self.itemSelectedBlock = selectBlock
    }
    
    // MARK: <NSTableViewDelegate>
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let column = tableColumn else {
            return nil
        }
        
        let cell = TitleCell()
        guard let item = self.itemsContainer.itemAtIndex(row) as? ProcessItem else {
            return nil
        }
        
        let valueKey = column.identifier.rawValue
        cell.textField?.stringValue = item[valueKey] ?? ""
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else {
            self.itemSelectedBlock(nil)
            return
        }
        let item = self.itemsContainer.itemAtIndex(tableView.selectedRow) as? ProcessItem
        self.itemSelectedBlock(item)
    }
}
