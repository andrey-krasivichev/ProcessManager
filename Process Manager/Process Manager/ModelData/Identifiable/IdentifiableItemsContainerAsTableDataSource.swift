//
//  IdentifiableItemsContainerAsTableDataSource.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 29.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

class TableDatsSourceFactory {
    static func sourceFromContainer(_ container: IdentifiableItemsContainer) -> NSTableViewDataSource {
        return IdentifiableItemsContainerAsTableDataSource(adaptee: container)
    }
}

private class IdentifiableItemsContainerAsTableDataSource: NSObject, NSTableViewDataSource {
    let adaptee: IdentifiableItemsContainer
    
    init(adaptee: IdentifiableItemsContainer) {
        self.adaptee = adaptee
    }
    
    // MARK: <NSTableViewDataSource>
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.adaptee.allItemsCount()
    }
    
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.adaptee.itemAtIndex(row)
    }
}
