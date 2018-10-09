//
//  ValleyTests.swift
//  ValleyTests
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import XCTest
@testable import Valley

class ValleyCacheTests: XCTestCase {
    
    override func setUp() {
        Valley.setup(capacityInBytes: 100)
    }
    
    func testBasicCacheStorage() {
        
        Valley.cache.add("teste", for: "id1", cost: 10)
        Valley.cache.add("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(Valley.cache.value(for: "id1"))
        XCTAssertNotNil(Valley.cache.value(for: "id2"))
        XCTAssertNil(Valley.cache.value(for: "id3"))
        XCTAssertFalse(Valley.cache.add("OverCapacity", for: "id4", cost: 120))
    }
    
    func testCacheEviction() {
        
        Valley.cache.add("teste", for: "id1", cost: 90)
        Valley.cache.add("teste", for: "id2", cost: 10)
        
        XCTAssertNotNil(Valley.cache.value(for: "id1"))
        
        Valley.cache.add("teste", for: "id3", cost: 20)
        
        XCTAssertNil(Valley.cache.value(for: "id2"))
    }
    
    func testUpdateCache() {
        Valley.cache.add("teste", for: "id1", cost: 50)
        XCTAssertNotNil(Valley.cache.value(for: "id1"))
        Valley.cache.add("teste", for: "id1", cost: 49)
        
        XCTAssertTrue(Valley.cache.add("teste", for: "id2", cost: 51))
        XCTAssertNotNil(Valley.cache.value(for: "id1"))
    }
    
    func testClearCache() {
        Valley.cache.add("teste", for: "id1", cost: 10)
        Valley.cache.add("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(Valley.cache.value(for: "id1"))
        XCTAssertNotNil(Valley.cache.value(for: "id2"))
        
        Valley.cache.clearCache()
        
        XCTAssertNil(Valley.cache.value(for: "id1"))
        XCTAssertNil(Valley.cache.value(for: "id2"))
    }
}
