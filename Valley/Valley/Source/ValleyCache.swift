//
//  ValleyCache.swift
//  Valley
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

// MARK: - Class
final internal class ValleyCache {
    
    // MARK: Private variables
    private let capacity: Int
    private var availableStorage: Int
    private let list = DoublyLinkedList<ValleyPayload>()
    private var nodesDict = [String: DoublyLinkedListNode<ValleyPayload>]()
    
    init(capacity: Int) {
        self.capacity = max(0, capacity)
        self.availableStorage = self.capacity
    }
    
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
    
    func getValue(for key: String) -> Any? {
        guard let node = nodesDict[key] else { return nil }
        
        list.moveToHead(node)
        return node.payload.value
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
