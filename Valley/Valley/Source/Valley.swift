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
    
    internal static var cache: ValleyCache = ValleyCache(capacity: 20 * 1024 * 1024)
    
    // MARK: Static setup

    /**
     Default cache capaciy is 20mb
     */
    public static func setup(capacityInBytes: Int) {
        self.cache.capacity = capacityInBytes
    }
}
