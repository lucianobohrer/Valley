//
//  ValleyJSON.swift
//  Valley
//
//  Created by Luciano Bohrer on 08/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

public class ValleyJSON<T> {

    // MARK: Internal methods
    /**
     This method downloads any kind of file from the `urlString` and pass through completion closure
     - parameter urlString: String of images url
     - parameter completion: Closure containing Data from the request
     - parameter onError: Closure triggered when an error has occurred
     */
    @discardableResult
    public static func request(url urlString: String,
                                  completion: @escaping (T) -> (Void),
                                  onError: @escaping (ValleyError?) -> (Void)) -> URLSessionTask? {
        if let value = Valley.cache.getValue(for: urlString) as? T {
            completion(value)
            return nil
        }
        
        let task = ValleyDownloader<T>
            .request(urlString: urlString,
                     onError: onError) { (json) -> (Void) in
                        DispatchQueue.main.async {
                            Valley.cache.setValue(json, for: urlString, cost: malloc_size(json as? UnsafeRawPointer))
                            completion(json)
                        }
        }
        
        defer {
            task?.resume()
        }
        return task
    }
}
