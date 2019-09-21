//
//  HomeViewController.swift
//  ValleyDemo
//
//  Created by Luciano Bohrer on 06/10/18.
//  Copyright © 2018 Luciano Bohrer. All rights reserved.
//

import UIKit
import Valley

// MARK: - Class
class HomeViewController: UIViewController {
    
    // MARK: Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (self.view.frame.size.width - 36) / 2
        layout.itemSize = CGSize(width: width, height: width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "CardCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: Private variables
    private lazy var model = HomeModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        var certsData: [Data]?
        Valley.cache.clearCache()
        
        if  let unsPlashCert = Bundle.main.url(forResource: "imgur.com", withExtension: "der"),
            let gitCert = Bundle.main.url(forResource: "gist.githubusercontent.com", withExtension: "der"),
            let cert1 = try? Data(contentsOf: unsPlashCert),
            let cert2 = try? Data(contentsOf: gitCert) {
            certsData = [cert1, cert2]
        }
        
        Valley.setup(capacityInBytes: 5 * 1024 * 1024, pinningCertificate: certsData)
        model.refreshData(page: 0)
    }
    
    private func setupViews() {
        self.view.addSubview(self.collectionView)
        collectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell",
                                                            for: indexPath) as? CardCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(url: model.source[indexPath.row].imageUrl)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - Home delegates
extension HomeViewController: HomeDelegates {
    
    func refreshData() {
        self.collectionView.reloadData()
    }
    
    func onError(error: Error) {
        let alert = UIAlertController(title: "Oops", message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
