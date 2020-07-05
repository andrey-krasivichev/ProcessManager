//
//  DynamicDataSourceChangesDecorator.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Cocoa

extension IdentifiableItemsContainerFactory {
    static func decoratedDynamicBatchChangesItemsContainer(_ container: inout IdentifiableItemsContainer, tableView: NSTableView?) {
        let decorator = IdentifiableItemsContainerDynamicBatchChangesTableSourceDecorator(decoratee: container)
        decorator.tableView = tableView
        container = decorator
    }
}

fileprivate class IdentifiableItemsContainerDynamicBatchChangesTableSourceDecorator: IdentifiableItemsContainer {
    
    var decoratee: IdentifiableItemsContainer
    var pendingRemoveIdentifiersContainer: IdentifiersContainer = IdentifiersContainerFactory.defaultContainer()
    var pendingInsertionsItemsContainer: IdentifiableItemsContainer = IdentifiableItemsContainerFactory.defaultContainer()
    var sectionIndexBlock: IntResultBlock = { return 0}
    var chunkingInterval: TimeInterval = 0.1
    var lastChunkTimestamp = Date.timeIntervalSinceReferenceDate
    var applyChangesTimer: Timer?
    weak var tableView: NSTableView?
    
    init(decoratee: IdentifiableItemsContainer) {
        self.decoratee = decoratee
    }
    
    // MARK: <IdentifiableItemsContainer>
    func addItem(_ item: Identifiable) {
        self.pendingInsertionsItemsContainer.addItem(item)
        self.requestChanges()
    }
    
    func addItems(_ items: [Identifiable]) {
        self.pendingInsertionsItemsContainer.addItems(items)
        self.requestChanges()
    }
    
    func removeItem(identifier: String) {
        self.pendingRemoveIdentifiersContainer.addIdentifier(identifier)
        self.requestChanges()
    }
    
    func removeItem(index: Int) {
        guard let identifier = self.itemAtIndex(index)?.identifier else {
            return
        }
        self.pendingRemoveIdentifiersContainer.addIdentifier(identifier)
        self.requestChanges()
    }
    
    func removeAllItems() {
        let items = self.decoratee.allItems()
        for item in items {
            self.pendingRemoveIdentifiersContainer.addIdentifier(item.identifier)
        }
        self.requestChanges()
    }
    
    func itemByIdentifier(_ identifier: String) -> Identifiable? {
        return self.decoratee.itemByIdentifier(identifier)
    }
    
    func itemAtIndex(_ index: Int) -> Identifiable? {
        return self.decoratee.itemAtIndex(index)
    }
    
    func indexOfItem(identifier: String) -> Int? {
        return self.decoratee.indexOfItem(identifier: identifier)
    }
    
    func containsItem(identifier: String) -> Bool {
        return self.decoratee.containsItem(identifier: identifier)
    }
    
    func allItems() -> [Identifiable] {
        return self.decoratee.allItems()
    }
    
    func allItemsCount() -> Int {
        return self.decoratee.allItemsCount()
    }
    
    // MARK: Private
    func requestChanges() {
        if self.applyChangesTimer?.isValid ?? false {
            self.applyChangesTimer?.invalidate()
            self.applyChangesTimer = nil
        }
        
        self.applyChangesTimer = Timer.scheduledTimer(withTimeInterval: self.chunkingInterval, repeats: false, block: { [weak self] (timer) in
            guard let self = self else {
                return
            }
            self.applyChanges()
        })
    }
    
    @objc private func applyChanges() {
        let identifiersToRemove = self.pendingRemoveIdentifiersContainer.allIdentifiers()
        self.pendingRemoveIdentifiersContainer.removeAllIdentifiers()
        
        self.tableView?.beginUpdates()
        let itemsToInsert = self.pendingInsertionsItemsContainer.allItems()
        self.pendingInsertionsItemsContainer.removeAllItems()
        
        self.applyRemovals(identifiers: identifiersToRemove)
        self.applyInsertions(items: itemsToInsert)
        self.tableView?.endUpdates()
    }
    
    private func applyRemovals(identifiers: [String]) {
        guard identifiers.count > 0, let tableView = self.tableView else {
            return
        }
        
        var indexSet = IndexSet()
        var removedIndicies: [IndexPath] = []
        let sectionIndex = self.sectionIndexBlock()
        for identifier in identifiers {
            let itemIndex = self.indexOfItem(identifier: identifier)
            if let removedItemIndex = itemIndex {
                let indexPath = IndexPath(item: removedItemIndex, section: sectionIndex)
                removedIndicies.append(indexPath)
                indexSet.insert(removedItemIndex)
            }
        }
        
        for identifier in identifiers {
            // extra enumeration is required due to index changes after removal
            self.decoratee.removeItem(identifier: identifier)
        }
        tableView.removeRows(at: indexSet, withAnimation: NSTableView.AnimationOptions.effectFade)
    }
    
    private func applyInsertions(items: [Identifiable]) {
        guard items.count > 0, let tableView = self.tableView else {
            return
        }
        
        let willInsertIdentifiersContainer = IdentifiersContainerFactory.defaultContainer()
        for item in items {
            if !self.containsItem(identifier: item.identifier) {
                willInsertIdentifiersContainer.addIdentifier(item.identifier)
            }
        }
        
        self.decoratee.addItems(items)
        let insertedIDs = willInsertIdentifiersContainer.allIdentifiers()
        guard insertedIDs.count > 0 else {
            return
        }
        var insertedIndicies = [IndexPath]()
        let sectionIndex = self.sectionIndexBlock()
        var indexSet = IndexSet()
        for identifier in insertedIDs {
            if let index = self.decoratee.indexOfItem(identifier: identifier) {
                insertedIndicies.append(IndexPath(item: index, section: sectionIndex))
                indexSet.insert(index)
            }
        }
        tableView.insertRows(at: indexSet, withAnimation: NSTableView.AnimationOptions.effectFade)
    }
}
