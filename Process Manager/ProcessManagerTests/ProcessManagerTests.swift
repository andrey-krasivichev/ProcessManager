//
//  ProcessManagerTests.swift
//  ProcessManagerTests
//
//  Created by Andrey Krasivichev on 05.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import XCTest
@testable import Process_Manager

class ProcessManagerTests: XCTestCase {

    var processFetcher: ProcessItemsFetcher!
    var didFetch: Bool = false
    
    override func setUpWithError() throws {
        self.processFetcher = ProcessItemsFetcher()
    }

    override func tearDownWithError() throws {
        self.processFetcher = nil
    }

    func testExample() throws {
        let promise = expectation(description: "Wait for fetch processes")
        self.processFetcher.itemsFetchedBlock = { (itemsById) in
            itemsById.count > 0 ? promise.fulfill() : XCTFail("There must be processes..")
        }
        self.processFetcher.startFetchEvents()
        self.wait(for: [promise], timeout: 1.0)
        self.processFetcher.finishFetchEvents()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
