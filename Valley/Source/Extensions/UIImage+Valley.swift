//
//  UIImage+Valley.swift
//  Valley
//
//  Created by Luciano Bohrer on 21/11/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    
    func compress(toWidth width: CGFloat = 512) -> UIImage? {

        var image: UIImage? = nil
        
        let targetWidth = min(self.size.width, width * 2)
        let ratio = self.size.width / targetWidth
        let targetHeight = self.size.height / ratio
        
        guard let cgi = self.cgImage, let colorSpace = cgi.colorSpace else { return nil }
        
        let bitmap = CGContext(data: nil,
                               width: Int(targetWidth),
                               height: Int(targetHeight),
                               bitsPerComponent: cgi.bitsPerComponent,
                               bytesPerRow: 4 * Int(targetWidth),
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        bitmap?.draw(cgi, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
    
        if let cgiImage = bitmap?.makeImage() {
            image = UIImage(cgImage: cgiImage)
        }
        
        return image
    }
}
