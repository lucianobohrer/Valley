//
//  Valley.swift
//  Valley
//
//  Created by Luciano Bohrer on 05/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

// MARK: - Class
final public class Valley {
    
    // MARK: Static variables
    
    public static private(set) var cache: ValleyCache = ValleyCache(capacity: 20 * 1024 * 1024)
    internal static var testing: Bool = false
    // MARK: Static setup

    /**
     Default cache capaciy is 20mb
     */
    public static func setup(capacityInBytes: Int) {
        self.cache.capacity = capacityInBytes
    }
    
    internal static func setup(capacityInBytes: Int, testing: Bool) {
        self.cache.capacity = capacityInBytes
        if testing {
            self.cache = ValleyCache(capacity: capacityInBytes)
            self.testing = testing
        }
    }
}
