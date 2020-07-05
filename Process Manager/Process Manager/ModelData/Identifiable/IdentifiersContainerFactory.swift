//
//  IdentifiersContainerFactory.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

public class IdentifiersContainerFactory {
    public static func defaultContainer() -> IdentifiersContainer {
        return IdentifiersContainerDefault()
    }
}

fileprivate class IdentifiersContainerDefault: IdentifiersContainer {
    var identifiers: NSMutableOrderedSet = NSMutableOrderedSet()
    
    // MARK: <IdentifiersContainer>
    func addIdentifier(_ identifier: String) {
        self.identifiers.add(identifier)
    }
    
    func addIdentifiers(_ identifiers: [String]) {
        self.identifiers.addObjects(from: identifiers)
    }
    
    func removeIdentifier(_ identifier: String) {
        self.identifiers.remove(identifier)
    }
    func removeIdentifier(index: Int) {
        guard index < self.identifiers.count, index >= 0 else {
            return
        }
        self.identifiers.removeObject(at: index)
    }
    
    func removeAllIdentifiers() {
        self.identifiers = NSMutableOrderedSet()
    }
    
    func containsIdentifier(_ identifier: String) -> Bool {
        return self.identifiers.index(of: identifier) != NSNotFound
    }
    
    func allIdentifiers() -> [String] {
        return self.identifiers.array as! [String]
    }
    
    func allIdentifiersCount() -> Int {
        return self.identifiers.count
    }
    
    func indexOfIdentifier(_ identifier: String) -> Int? {
        let index = self.identifiers.index(of: identifier)
        return index == NSNotFound ? nil : index
    }
}
