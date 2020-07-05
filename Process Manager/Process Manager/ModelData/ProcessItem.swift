//
//  ProcessItem.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 29.06.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import Foundation

struct ProcessItem: Identifiable {
    let identifier: String
    let name: String
    let owner: String
    
    subscript(key: String) -> String? {
        switch key {
        case "identifier":
            return self.identifier
        case "name":
            return self.name
        case "owner":
            return self.owner
        default:
            return nil
        }
    }
}
