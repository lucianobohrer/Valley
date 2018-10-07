//
//  ValleyImageView.swift
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
    public func valleyImage(url urlString: String, placeHolder: UIImage? = nil, fadeIn: Bool? = true) {
        self.image = placeHolder
        if let value = Valley.cache.getValue(for: urlString.appending("\(self.bounds.size.width)")) as? Data, let img = UIImage(data: value) {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.image = img
                                
            }, completion: nil)
            return
        }
        
        ValleyDownloader.download(urlString: urlString) { [weak self] (data) -> (Void) in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                if  let imageResized = UIImage(data: data)?.resize(withWidth: self.bounds.size.width),
                    let dataResized = imageResized.jpegData(compressionQuality: 1.0) {
                        Valley.cache.setValue(dataResized,
                                              for: urlString.appending("\(self.bounds.size.width)"),
                                              cost: dataResized.count)
                    UIView.transition(with: self,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.image = imageResized
                                        
                    }, completion: nil)
                }
            }
        }
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
