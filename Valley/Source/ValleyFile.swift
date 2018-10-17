//
//  ValleyFile.swift
//  Valley
//
//  Created by Luciano Bohrer on 08/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

public class ValleyFile<T> {

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
                                  onError: ((ValleyError?) -> (Void))? = nil) -> URLSessionTask? {
        var rawData: Any?
        
        Valley.cache.value(for: urlString) { (item) in
            rawData = item
        }
        
        if let value = rawData as? T {
            completion(value)
            return nil
        }
        
        let task = ValleyDownloader<T>
            .request(urlString: urlString,
                     onError: onError) { (file, size) -> (Void) in
                        DispatchQueue.main.async {
                            Valley.cache.add(file, for: urlString, cost: size)
                            completion(file)
                        }
        }
        
        defer {
            task?.resume()
        }
        return task
    }
}
