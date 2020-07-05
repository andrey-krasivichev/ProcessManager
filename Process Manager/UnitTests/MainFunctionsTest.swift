//
//  MainFunctionsTest.swift
//  Process Manager
//
//  Created by Andrey Krasivichev on 05.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import XCTest
@testable import Process_Manager

class MainFunctionsTest: XCTestCase {

    var fetcher: ProcessItemsFetcher!
    var itmesFetched: Bool = false
    
    override func setUp() {
        self.fetcher = ProcessItemsFetcher()
        fetcher.itemsFetchedBlock = { [weak self] (itemsById) in
            self?.itmesFetched = itemsById.count > 0
        }
        super.setUp()
    }
    
    override func tearDown() {
        self.fetcher = nil
        super.tearDown()
    }
    
    func testExample() throws {
        print(">> test")
        
        fetcher.startFetchEvents()
        //self.wait(for: [], timeout: 3.0)
        fetcher.finishFetchEvents()
        XCTAssert(self.itmesFetched, "Processes must be fetched")
    }

}
