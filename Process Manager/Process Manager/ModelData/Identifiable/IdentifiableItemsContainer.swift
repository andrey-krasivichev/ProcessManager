//
//  IdentifiableItemsContainer.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 29.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

protocol IdentifiableItemsContainer {
    func addItem(_ item: Identifiable)
    func addItems(_ items: [Identifiable])
    
    func removeItem(identifier: String)
    func removeItem(index: Int)
    func removeAllItems()
    
    func itemByIdentifier(_ identifier: String) -> Identifiable?
    func itemAtIndex(_ index: Int) -> Identifiable?
    func indexOfItem(identifier: String) -> Int?
    
    func containsItem(identifier: String) -> Bool
    func allItems() -> [Identifiable]
    func allItemsCount() -> Int
}
