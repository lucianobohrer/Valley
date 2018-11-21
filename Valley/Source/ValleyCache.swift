//
//  ValleyCache.swift
//  Valley
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//
import Foundation

// MARK: - Class
final public class ValleyCache: NSObject {
    
    // MARK: Internal variables
    internal var capacity: Int
    
    // MARK: Private variables
    private var queue: DispatchQueue = DispatchQueue(label: "cache-queue")
    internal private(set) var items: [ValleyPayload] = []
    
    // MARK: Initializers
    init(capacity: Int) {
        self.capacity = max(0, capacity)
    }
    
    // MARK: Internal methods
    func add(_ value: Any, for key: String, cost: Int) {
        self.queue.sync {
            if cost <= self.capacity {
                let payload = ValleyPayload(key: key, value: value, cost: cost)
            
                if let index = self.items.map({$0.key}).firstIndex(of: key) {
                    self.items.remove(at: index)
                }
            
                while self.availableStorage() < cost, self.items.count > 0 {
                    self.items.removeFirst()
                }
            
                self.items.append(payload)
            }
        }
    }
    
    // MARK: Internal methods
    func value(for key: String, completion: ((Any?) -> Void)) {
        self.queue.sync {
            if let index = items.map({$0.key}).firstIndex(of: key) {
                let rearranged = items.remove(at: index)
                self.items.append(rearranged)
                completion(rearranged.value)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: Private methods
    func availableStorage() -> Int {
        return max(0, (self.capacity - self.items.compactMap({ $0.cost }).reduce(0, +)))
    }
    
    public func clearCache() {
        self.items.removeAll()
    }
}

// MARK: - Definitions
extension ValleyCache {
    struct ValleyPayload {
        let key: String
        var value: Any
        var cost: Int
    }
}
