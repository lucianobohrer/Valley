//
//  ValleyDownloader.swift
//  Valley
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import Foundation

/**
    Helper Class responsible for making http requests in order to download any kind of file
 */

// MARK: - Class
final class ValleyDownloader {
    
    // MARK: Error definitions
    enum Error: String, Swift.Error {
        case generic = "Unexpected error ocurred"
        case invalidUrl = "Error parsing string url"
    }
    
    // MARK: Static methods
    
    /**
     Download method for any kind of file returning the URLSessionTask to control the request if needed
     */
    @discardableResult
    static func downloadTask(urlString: String,
                             onError: ((Error?) -> (Void))? = nil,
                             completion: @escaping (Data) -> (Void)) -> URLSessionTask? {
        guard let url = URL(string: urlString) else {
            onError?(.invalidUrl)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data, error == nil else {
                onError?(.generic)
                return
            }
            completion(data)
        }
        task.resume()
        return task
    }
}
