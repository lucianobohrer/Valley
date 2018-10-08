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
    private var availableStorage: Int
    private let list = DoublyLinkedList<ValleyPayload>()
    private var nodesDict = [String: DoublyLinkedListNode<ValleyPayload>]()
    
    // MARK: Initializers
    init(capacity: Int) {
        self.capacity = max(0, capacity)
        self.availableStorage = self.capacity
    }
    
    // MARK: Internal methods
    func setValue(_ value: Any, for key: String, cost: Int) {
        let payload = ValleyPayload(key: key, value: value, cost: cost)
        
        if let node = nodesDict[key] {
            node.payload = payload
            list.moveToHead(node)
        } else {
            while availableStorage < cost, list.count > 0 {
                if  let removedNode = list.removeLast() {
                    self.availableStorage = max(0, self.availableStorage + removedNode.payload.cost)
                    nodesDict[removedNode.payload.key] = nil
                }
            }
            
            if availableStorage >= cost {
                let node = list.addHead(payload)
                nodesDict[key] = node
                self.availableStorage -= cost
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
