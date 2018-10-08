//
//  Data+Valley.swift
//  Valley
//
//  Created by Luciano Bohrer on 08/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

public extension Data {
    
    // MARK: Internal methods
    /**
     This method downloads any kind of file from the `urlString` and pass through completion closure
     - parameter urlString: String of images url
     - parameter completion: Closure containing Data from the request
     - parameter onError: Closure triggered when an error has occurred
     */
    @discardableResult
    public static func valleyData(url urlString: String,
                                  completion: @escaping (Data) -> (Void),
                                  onError: @escaping (ValleyError?) -> (Void)) -> URLSessionTask? {
        if let value = Valley.cache.getValue(for: urlString) as? Data {
            completion(value)
            return nil
        }
        
        let task = ValleyDownloader<Data>
            .request(urlString: urlString,
                     onError: onError) { (data) -> (Void) in
                        DispatchQueue.main.async {
                            Valley.cache.setValue(data, for: urlString, cost: data.count)
                            completion(data)
                     }
        }
        
        defer {
            task?.resume()
        }
        return task
    }
}
