//
//  IdentifiersContainer.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

public protocol IdentifiersContainer {
    func addIdentifier(_ identifier: String)
    func addIdentifiers(_ identifiers: [String])
    func removeIdentifier(_ identifier: String)
    func removeIdentifier(index: Int)
    func containsIdentifier(_ identifier: String) -> Bool
    func indexOfIdentifier(_ identifier: String) -> Int?
    func allIdentifiers() -> [String]
    func allIdentifiersCount() -> Int
    func removeAllIdentifiers()
}
