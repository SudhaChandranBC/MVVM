//
//  ViewController.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 26/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController {
    
    var dataSource: BannerDataSource
    let dataProvider: BannerDataProvider
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        dataSource = BannerDataSource(banners: [])
        dataProvider = BannerDataProvider(client: APIClient())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }

    private func setupCollectionView() {
//        dataSource.registerCells(for: bannerCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        dataProvider.loadRaceBanner(completion: {
            [weak self](response, error) in
            if let weakSelf = self {
                if (error == nil) {
                    let dataChanged = weakSelf.dataSource.updateImageBanner(newBanners: response.banners)
                    if dataChanged {
                        weakSelf.bannerCollectionView.reloadData()
                    }
                }
            }
        })
    }
}

extension BannerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataSource.cellIdentifier(), for: indexPath) as? BannerCollectionViewCell {
            if let url = URL(string: dataSource.imageUrl(at: indexPath)) {
                cell.imageView.load(url: url)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

