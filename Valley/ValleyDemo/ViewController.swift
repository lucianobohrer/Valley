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
    
    private var source: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (self.view.frame.size.width - 20) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        Valley.setup(capacityInBytes: 20 * 1024 * 1024)
        
        ValleyJSON<[[String: Any]]>
            .request(url: "https://pastebin.com/raw/wgkJgazE",
                     completion: { (source) -> (Void) in
                        self.source = source
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                     },
                    onError: { error in
                        print(error?.localizedDescription ?? "")
                    })
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
        
        if  let urls = source[indexPath.row]["urls"] as? [String: Any],
            let small = urls["small"] as? String {
        
            cell.imageView.valleyImage(url: small,
                                       placeholder: UIImage(named: "placeholder"))

        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
