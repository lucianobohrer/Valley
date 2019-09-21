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
    Initially, It supports json files, any Data file or Images
 */

// MARK: - Class
internal final class ValleyDownloader<T>: NSObject, URLSessionDelegate {
    
    // MARK: Static methods
    
    /**
     Download method for any kind of file returning the URLSessionTask to control the request if needed
     */
    
    @discardableResult
    internal static func request(urlString: String,
                               onError: ((ValleyError?) -> Void)? = nil,
                               completion: ((T, Int) -> Void)? = nil) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            onError?(.invalidUrl)
            return nil
        }
        print(url)
        let configuration = URLSessionConfiguration.default
        let delegate = ValleyPinning()
        
        let session = URLSession(configuration: configuration,
                                 delegate: delegate,
                                 delegateQueue:OperationQueue.main)
        
        let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data, error == nil else {
                onError?(.generic)
                return
            }
            
            if let parsedData = self.parseData(data: data) {
                completion?(parsedData, data.count)
                return
            } else {
                onError?(.invalidParse)
            }
        }

        return task
    }
    
    private static func parseData(data: Data) -> T? {
        
        switch T.self {
        case is UIImage.Type:
            return UIImage(data: data) as? T
        case is [String : Any].Type, is [[String: Any]].Type:
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? T
            } catch (let error) {
                print(error.localizedDescription)
                return nil
            }
        default:
            return data as? T
        }
    }
}

// MARK: - Errors definition
public enum ValleyError: String, Swift.Error {
    case generic = "Unexpected error ocurred"
    case invalidParse = "Error parsing data to file type"
    case invalidUrl = "Error parsing string url"
}

