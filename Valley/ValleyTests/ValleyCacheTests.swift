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
        Valley.setup(capacityInBytes: 100,
                     testing: true)
    }
    
    func testBasicCacheStorage() {
        
        Valley.cache.setValue("teste", for: "id1", cost: 10)
        Valley.cache.setValue("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(Valley.cache.getValue(for: "id1"))
        XCTAssertNotNil(Valley.cache.getValue(for: "id2"))
    }
    
    func testCacheEviction() {
        
        Valley.cache.setValue("teste", for: "id1", cost: 90)
        Valley.cache.setValue("teste", for: "id2", cost: 10)
        
        XCTAssertNotNil(Valley.cache.getValue(for: "id1"))
        
        Valley.cache.setValue("teste", for: "id3", cost: 20)
        XCTAssertNil(Valley.cache.getValue(for: "id2"))

    }
    
    func testClearCache() {
        Valley.cache.setValue("teste", for: "id1", cost: 10)
        Valley.cache.setValue("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(Valley.cache.getValue(for: "id1"))
        XCTAssertNotNil(Valley.cache.getValue(for: "id2"))
        Valley.cache.clearCache()
        XCTAssertNil(Valley.cache.getValue(for: "id1"))
        XCTAssertNil(Valley.cache.getValue(for: "id2"))
    }
    
    func testPerformanceLinkedList() {
        // This is an example of a performance test case.
        self.measure {
            Valley.cache.setValue("test", for: "id1", cost: 10)
            Valley.cache.setValue("test", for: "id2", cost: 10)
            Valley.cache.setValue("test", for: "id3", cost: 10)
            Valley.cache.setValue("test", for: "id4", cost: 10)
            Valley.cache.setValue("test", for: "id5", cost: 10)
            
            _ = Valley.cache.getValue(for: "id3")
            _ = Valley.cache.getValue(for: "id1")
            _ = Valley.cache.getValue(for: "id5")
        }
    }
    
    func testPerformanceArray() {
        var array: [ValleyCache.ValleyPayload] = []
        let getValue: ((String) -> (ValleyCache.ValleyPayload?)) = { key in
            if let value = array.filter({$0.key == key }).first {
                array.removeAll(where: { $0.key == key })
                array.append(value)
                return value
            }
            return nil
        }
        
        self.measure {
            array.append(ValleyCache.ValleyPayload.init(key: "id1", value: "test", cost: 10))
            array.append(ValleyCache.ValleyPayload.init(key: "id2", value: "test", cost: 10))
            array.append(ValleyCache.ValleyPayload.init(key: "id3", value: "test", cost: 10))
            array.append(ValleyCache.ValleyPayload.init(key: "id4", value: "test", cost: 10))
            array.append(ValleyCache.ValleyPayload.init(key: "id5", value: "test", cost: 10))
            
            _ = getValue("id3")
            _ = getValue("id1")
            _ = getValue("id5")
        }
    }
}
