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
    
    var cache: ValleyCache?
    
    override func setUp() {
        self.cache = ValleyCache(capacity: 100)
    }
    
    func testBasicCacheStorage() {
        
        self.cache?.setValue("teste", for: "id1", cost: 10)
        self.cache?.setValue("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(cache?.getValue(for: "id1"))
        XCTAssertNotNil(cache?.getValue(for: "id2"))
    }
    
    func testCacheEviction() {
        
        self.cache?.setValue("teste", for: "id1", cost: 90)
        self.cache?.setValue("teste", for: "id2", cost: 10)
        
        XCTAssertNotNil(cache?.getValue(for: "id1"))
        
        self.cache?.setValue("teste", for: "id3", cost: 20)
        XCTAssertNil(cache?.getValue(for: "id2"))

    }
    
    func testClearCache() {
        self.cache?.setValue("teste", for: "id1", cost: 10)
        self.cache?.setValue("teste", for: "id2", cost: 30)
        
        XCTAssertNotNil(cache?.getValue(for: "id1"))
        XCTAssertNotNil(cache?.getValue(for: "id2"))
        self.cache?.clearCache()
        XCTAssertNil(cache?.getValue(for: "id1"))
        XCTAssertNil(cache?.getValue(for: "id2"))
    }
    
    func testPerformanceLinkedList() {
        // This is an example of a performance test case.
        self.measure {
            self.cache?.setValue("test", for: "id1", cost: 10)
            self.cache?.setValue("test", for: "id2", cost: 10)
            self.cache?.setValue("test", for: "id3", cost: 10)
            self.cache?.setValue("test", for: "id4", cost: 10)
            self.cache?.setValue("test", for: "id5", cost: 10)
            
            _ = self.cache?.getValue(for: "id3")
            _ = self.cache?.getValue(for: "id1")
            _ = self.cache?.getValue(for: "id5")
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
