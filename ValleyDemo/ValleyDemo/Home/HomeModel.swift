//
//  HomeModel.swift
//  ValleyDemo
//
//  Created by Luciano Bohrer on 09/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//
import Valley
import Foundation

// MARK: - Class
class HomeModel: NSObject {
    
    // MARK: Internal variables
    weak var delegate: HomeDelegates?
    var source: [HomeItem] = []
    
    init(delegate: HomeDelegates) {
        self.delegate = delegate
    }
    
    // MARK: Internal methods
    func refreshData(page: Int) {
        ValleyFile<[[String: Any]]>.request(url: Endpoints.home.rawValue, completion: { [weak self] (items) -> (Void) in
            
            for item in items {
                if  let urls = item["urls"] as? [String: Any],
                    let url = urls["full"] as? String,
                    let id = item ["id"] as? String {
                    self?.source.append(HomeItem(id: id, imageUrl: url))
                }
            }
            self?.delegate?.refreshData()
        }) { [weak self] (error) -> (Void) in
            if let error = error {
                self?.delegate?.onError(error: error)
            } else {
                self?.delegate?.onError(error: ValleyError.generic)
            }
        }
    }
}
protocol HomeDelegates: class {
    func refreshData()
    func onError(error: Error)
}
