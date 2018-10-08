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
     - parameter onError: Closure triggered when an error has occurred
    */
    @discardableResult
    public func valleyImage(url urlString: String,
                            placeholder: UIImage? = nil,
                            option: AnimationOptions? = .transitionCrossDissolve,
                            onError: @escaping ((ValleyError?) -> (Void)) = { _ in }) -> URLSessionTask? {
        self.image = placeholder
        if let value = Valley.cache.getValue(for: urlString.appending("\(self.bounds.size.width)")) as? Data, let img = UIImage(data: value) {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = img
                                
            }, completion: nil)
            return nil
        }
        
        let task = ValleyDownloader<UIImage>.request(urlString: urlString,
                                             onError: onError) { [weak self] (image) -> (Void) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let resizedImage = image.resize(withWidth: self.bounds.size.width)
                if let dataResized = resizedImage.jpegData(compressionQuality: 1.0) {
                    Valley.cache.setValue(dataResized,
                                          for: urlString.appending("\(self.bounds.size.width)"),
                                          cost: dataResized.count)
                    UIView.transition(with: self,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.image = resizedImage
                                        
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

// MARK: - Extension UIImage
extension UIImage {
    func resize(withWidth width: CGFloat) -> UIImage {
        let ratio = self.size.width / width
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: self.size.height / ratio), false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: self.size.height / ratio)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
