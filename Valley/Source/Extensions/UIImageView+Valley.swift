//
//  UIImageView+Valley.swift
//  Valley
//
//  Created by Luciano Bohrer on 05/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import UIKit
import Foundation

/**
    Helper class to integrate Valley functionalities into UIImageView
 */

// MARK: UIImageView Extensions
public extension UIImageView {
    
    // MARK: Internal methods
    /**
        This method downloads the image from the `urlString` and set to the `UIImageView` image property
     
     - parameter urlString: String of images url
     - parameter placeholder: Placeholder to be used during download
     - parameter option: `AnimationOptions` to be used when image is set to the view
     - parameter onSuccess: Closure triggered when the request was successful
     - parameter onError: Closure triggered when an error has occurred
    */
    @discardableResult
    public func valleyImage(url urlString: String,
                            placeholder: UIImage? = nil,
                            option: AnimationOptions? = .transitionCrossDissolve,
                            onSuccess: ((UIImage) -> Void)? = nil,
                            onError: ((ValleyError?) -> Void)? = nil) -> URLSessionTask? {
        self.image = placeholder
        let widthTarget = self.frame.width
        let identifier =  "\(urlString)\(widthTarget)"
        var rawData: Any?
        
        Valley.cache.value(for: identifier) { (item) in
            rawData = item
        }
        
        if let value = rawData as? Data, let img = UIImage(data: value) {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = img
                                
            }, completion: nil)
            return nil
        } else {
            
            let task = ValleyDownloader<UIImage>
                .request(urlString: urlString,
                         onError: onError) { [weak self] (image, size) -> (Void) in
                            guard let `self` = self else {
                                onError?(.generic)
                                return
                            }
                            
                            if  let resizedImage = image.compress(toWidth: widthTarget),
                                let data = resizedImage.pngData() {
                                Valley.cache.add(data,
                                                 for: identifier,
                                                 cost: data.count)
                                DispatchQueue.main.async {
                                    UIView.transition(with: self,
                                                      duration: 0.3,
                                                      options: .transitionCrossDissolve,
                                                      animations: {
                                                        self.image = resizedImage
                                                        onSuccess?(image)
                                    }, completion: nil)
                                }
                            }
            }
         
            defer {
                task?.resume()
            }
            return task
        }
    }
}
