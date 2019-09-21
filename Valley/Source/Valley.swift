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
    public static private(set) var pinningCertificateData: [Data]?
    
    // MARK: Private variables
    static var hasSSLPinneEnabled: Bool {
        return pinningCertificateData != nil
    }
    
    
    // MARK: Static setup
    /**
     Default cache capaciy is 20mb
     */
        public static func setup(capacityInBytes: Int, pinningCertificate: [Data]? = nil) {
        self.cache.capacity = capacityInBytes
        self.pinningCertificateData = pinningCertificate
    }
}
