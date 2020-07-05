//
//  IdentifiableItemsContainerOrderedInsertionsDecorator.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

extension IdentifiableItemsContainerFactory {
    static func orderedInsertionsContainer(_ container: inout IdentifiableItemsContainer, ascending: Bool = false) {
        container = IdentifiableItemsContainerIdentifierSortingInsertionsDecorator(decoratee: container, ascending: ascending)
    }
}

fileprivate class IdentifiableItemsContainerIdentifierSortingInsertionsDecorator: IdentifiableItemsContainer {
    var decoratee: IdentifiableItemsContainer
    let ascendingInsertions: Bool
    var orderedIdentifiers: NSMutableOrderedSet = NSMutableOrderedSet()
    
    init(decoratee: IdentifiableItemsContainer, ascending: Bool) {
        self.decoratee = decoratee
        self.ascendingInsertions = ascending
    }
    
    // MARK: <IdentifiableItemsContainer>
    func addItem(_ item: Identifiable) {
        
        let compareResult = self.ascendingInsertions ? ComparisonResult.orderedAscending : ComparisonResult.orderedDescending
        let itemId = item.identifier
        let identifiers = self.orderedIdentifiers.array as! [String]
        for (index, identifier) in identifiers.enumerated() {
            if self.compareIdentifiers(identifier, second: itemId) == compareResult {
                self.orderedIdentifiers.insert(itemId, at: index)
                self.decoratee.addItem(item)
                return
            }
        }
        
        self.orderedIdentifiers.add(itemId)
        self.decoratee.addItem(item)
    }
    
    func addItems(_ items: [Identifiable]) {
        for item in items {
            self.addItem(item)
        }
    }
    
    func removeItem(identifier: String) {
        self.orderedIdentifiers.remove(identifier)
        self.decoratee.removeItem(identifier: identifier)
    }
    
    func removeItem(index: Int) {
        if index < self.orderedIdentifiers.count, index >= 0 {
            self.orderedIdentifiers.removeObject(at: index)
        }
        self.decoratee.removeItem(index: index)
    }
    
    func removeAllItems() {
        self.orderedIdentifiers = NSMutableOrderedSet()
        self.decoratee.removeAllItems()
    }
    
    func itemByIdentifier(_ identifier: String) -> Identifiable? {
        return self.decoratee.itemByIdentifier(identifier)
    }
    
    func itemAtIndex(_ index: Int) -> Identifiable? {
        guard index < self.orderedIdentifiers.count, index >= 0 else {
            return nil
        }
        let identifier = self.orderedIdentifiers.object(at: index) as! String
        return self.decoratee.itemByIdentifier(identifier)
    }
    
    func indexOfItem(identifier: String) -> Int? {
        let index = self.orderedIdentifiers.index(of: identifier)
        return index == NSNotFound ? nil : index
    }
    
    func containsItem(identifier: String) -> Bool {
        return self.orderedIdentifiers.contains(identifier)
    }
    
    func allItems() -> [Identifiable] {
        let identifiers: [String] = self.orderedIdentifiers.array as! [String]
        var items: [Identifiable] = []
        for identifier in identifiers {
            if let item = self.decoratee.itemByIdentifier(identifier) {
                items.append(item)
            }
        }
        return items
    }
    
    func allItemsCount() -> Int {
        return self.decoratee.allItemsCount()
    }
    
    private func compareIdentifiers(_ first: String, second: String) -> ComparisonResult {
        if first.count < second.count {
            return ComparisonResult.orderedAscending
        }
        if first.count > second.count {
            return ComparisonResult.orderedDescending
        }
        return first.compare(second)
    }
}
