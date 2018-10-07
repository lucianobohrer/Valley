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
    
    // MARK: Static methods
    
    /**
     Download method for any kind of file returning the URLSessionTask to control the request
     */
    @discardableResult
    static func download(urlString: String, completion: @escaping (Data) -> (Void)) -> URLSessionTask? {
        guard let url = URL(string: urlString) else {
            debugPrint("VALLEY: INVALID URL")
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Generic Error Downloading Image")
                return
            }
            completion(data)
        }
        task.resume()
        return task
    }
}
