//
//  CardCollectionViewCell.swift
//  Valley-Demo
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import UIKit
import Valley

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(url: String) {
        self.imageView.valleyImage(url: url,
                                   placeholder: UIImage(named: "placeholder"))
    }
}
