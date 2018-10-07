//
//  ViewController.swift
//  ValleyDemo
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import UIKit
import Valley

class ViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main),
                                    forCellWithReuseIdentifier: "CardCollectionViewCell")
        }
    }
    
    private let source = ["https://upload.wikimedia.org/wikipedia/commons/8/8b/Ft5_3mb.JPG",
                        "https://upload.wikimedia.org/wikipedia/commons/a/a3/GNR_London_Stadium_2017_3_%28cropped%29.jpg",
                        "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        "https://images.pexels.com/photos/92658/pexels-photo-92658.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        "https://images.pexels.com/photos/268633/pexels-photo-268633.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260G",
                        "https://images.pexels.com/photos/355749/pexels-photo-355749.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        "https://images.pexels.com/photos/315999/pexels-photo-315999.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        "https://upload.wikimedia.org/wikipedia/commons/8/8b/Ft5_3mb.JPG",
                        "https://upload.wikimedia.org/wikipedia/commons/a/a3/GNR_London_Stadium_2017_3_%28cropped%29.jpg",
                        "https://upload.wikimedia.org/wikipedia/commons/8/8b/Ft5_3mb.JPG",
                        "https://upload.wikimedia.org/wikipedia/commons/a/a3/GNR_London_Stadium_2017_3_%28cropped%29.jpg",
                        "https://upload.wikimedia.org/wikipedia/commons/8/8b/Ft5_3mb.JPG",
                        "https://upload.wikimedia.org/wikipedia/commons/a/a3/GNR_London_Stadium_2017_3_%28cropped%29.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (self.view.frame.size.width - 20) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell",
                                                            for: indexPath) as? CardCollectionViewCell
            else {
                return UICollectionViewCell()
        }
        

        cell.imageView.valleyImage(url: source[indexPath.row],
                                   placeHolder: UIImage(named: "placeholder"))
    
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
