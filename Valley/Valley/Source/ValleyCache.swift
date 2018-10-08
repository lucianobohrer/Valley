//
//  ValleyCache.swift
//  Valley
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//
import Foundation

// MARK: - Class
final public class ValleyCache {
    
    // MARK: Internal variables
    internal var capacity: Int
    
    // MARK: Private variables
    private let list = DoublyLinkedList<ValleyPayload>()
    private var nodesDict = [String: DoublyLinkedListNode<ValleyPayload>]()
    
    // MARK: Initializers
    init(capacity: Int) {
        self.capacity = max(0, capacity)
    }
    
    // MARK: Internal methods
    func setValue(_ value: Any, for key: String, cost: Int) {
        let payload = ValleyPayload(key: key, value: value, cost: cost)
        
        if let node = nodesDict[key] {
            node.payload = payload
            self.list.moveToHead(node)
        } else {
            while self.availableStorage() < cost, nodesDict.count > 0 {
                if  let removedNode = self.list.removeLast() {
                    nodesDict[removedNode.payload.key] = nil
                } else if self.nodesDict.count == 1 {
                    nodesDict.removeAll()
                }
            }
            let available = self.availableStorage()
            if available > 0 && available >= cost {
                let node = list.addHead(payload)
                nodesDict[key] = node
            } else {
                debugPrint("VALLEY: INSUFFICIENT MEMORY SPACE")
            }
        }
    }
    
    // MARK: Internal methods
    func getValue(for key: String) -> Any? {
        guard let node = nodesDict[key] else { return nil }
        list.moveToHead(node)
        return node.payload.value
    }
    
    // MARK: Private methods
    func availableStorage() -> Int {
        return max(0, (self.capacity - self.nodesDict.compactMap({ $0.value.payload.cost }).reduce(0, +)))
    }
    
    @objc public func clearCache() {
        self.list.removeAll()
        self.nodesDict.removeAll()
    }
}

// MARK: - Definitions
extension ValleyCache {
    struct ValleyPayload {
        let key: String
        let value: Any
        let cost: Int
    }
}
