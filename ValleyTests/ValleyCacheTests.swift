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
        
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNotNil(data)
        }
        
        Valley.cache.value(for: "id2") { (data) in
            XCTAssertNotNil(data)
        }
        
        Valley.cache.value(for: "id3") { (data) in
            XCTAssertNil(data)
        }
        
        Valley.cache.add("OverCapacity", for: "id4", cost: 120)
        
        Valley.cache.value(for: "id4") { (data) in
            XCTAssertNil(data)
        }
        
        XCTAssertEqual(Valley.cache.availableStorage(), 60)
    }
    
    func testCacheEviction() {
        
        Valley.cache.add("teste", for: "id1", cost: 90)
        Valley.cache.add("teste", for: "id2", cost: 10)
        
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNotNil(data)
        }
        
        Valley.cache.add("teste", for: "id3", cost: 20)
        
        Valley.cache.value(for: "id2") { (data) in
            XCTAssertNil(data)
        }    }
    
    func testUpdateCache() {
        Valley.cache.add("teste", for: "id1", cost: 50)
        
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNotNil(data)
        }
        
        Valley.cache.add("teste", for: "id1", cost: 49)
        
        Valley.cache.add("teste", for: "id2", cost: 51)
        Valley.cache.value(for: "id2") { (data) in
            XCTAssertNotNil(data)
        }
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNotNil(data)
        }
    }
    
    func testClearCache() {
        Valley.cache.add("teste", for: "id1", cost: 10)
        Valley.cache.add("teste", for: "id2", cost: 30)
        
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNotNil(data)
        }
        Valley.cache.value(for: "id2") { (data) in
            XCTAssertNotNil(data)
        }
        
        Valley.cache.clearCache()
        
        Valley.cache.value(for: "id1") { (data) in
            XCTAssertNil(data)
        }
        Valley.cache.value(for: "id2") { (data) in
            XCTAssertNil(data)
        }
    }
    
    func testMassiveSearch() {
        let cache = ValleyCache(capacity: 1000)
        DispatchQueue.global().async {
            for i in 0..<1000 {
                cache.add("value\(i)", for: "item\(i)", cost: 1)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            for i in 0..<1000 {
                DispatchQueue.global().async {
                    cache.value(for: "item\(i)", completion: { (item) in
                        if item == nil {
                            // Before using queue, trying to get the value usually crashed the app
                            print("===== item\(i) is nil  ======")
                        }
                    })
                }
            }
        }
    }
}
