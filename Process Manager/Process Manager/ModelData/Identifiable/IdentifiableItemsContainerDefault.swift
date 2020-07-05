//
//  IdentifiableItemsContainerDefault.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 29.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

extension IdentifiableItemsContainerFactory {
    static func defaultContainer() -> IdentifiableItemsContainer {
        return IdentifiableItemsContainerDefault()
    }
}

fileprivate class IdentifiableItemsContainerDefault: IdentifiableItemsContainer {
    
    var identifiers: [String] = []
    var itemsByIdentifier: [String : Identifiable] = [:]
    
    // MARK: <IdentifiableItemsContainer>
    func addItem(_ item: Identifiable) {
        let identifier = item.identifier
        if self.itemsByIdentifier[identifier] != nil {
            self.itemsByIdentifier[identifier] = item
            return
        }
        self.identifiers.append(identifier)
        self.itemsByIdentifier[identifier] = item
    }
    
    func addItems(_ items: [Identifiable]) {
        for item in items {
            self.addItem(item)
        }
    }
    
    func removeItem(identifier: String) {
        if !self.containsItem(identifier: identifier) {
            return
        }
        guard let idIndex = self.identifiers.firstIndex(of: identifier) else {
            return
        }
        self.identifiers.remove(at: idIndex)
        self.itemsByIdentifier[identifier] = nil
    }
    
    func removeItem(index: Int) {
        guard index < self.identifiers.count, index >= 0 else {
            return
        }
        let identifier = self.identifiers[index]
        self.identifiers.remove(at: index)
        self.itemsByIdentifier[identifier] = nil
    }
    
    func removeAllItems() {
        self.identifiers = []
        self.itemsByIdentifier = [:]
    }
    
    func itemByIdentifier(_ identifier: String) -> Identifiable? {
        return self.itemsByIdentifier[identifier]
    }
    
    func itemAtIndex(_ index: Int) -> Identifiable? {
        guard index < self.identifiers.count, index >= 0 else {
            return nil
        }
        let identifier = self.identifiers[index]
        return self.itemsByIdentifier[identifier]
    }
    
    func indexOfItem(identifier: String) -> Int? {
        return self.identifiers.firstIndex(of: identifier)
    }
    
    func containsItem(identifier: String) -> Bool {
        return self.itemsByIdentifier[identifier] != nil
    }
    
    func allItems() -> [Identifiable] {
        var items: [Identifiable] = []
        let localIdentifiers = self.identifiers
        for identifier in localIdentifiers {
            if let item = self.itemsByIdentifier[identifier] {
                items.append(item)
            }
        }
        return items
    }
    
    func allItemsCount() -> Int {
        return self.identifiers.count
    }
}
