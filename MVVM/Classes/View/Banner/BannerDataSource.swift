//
//  BannerDataSource.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit


struct BannerDataSource {
    
    init(banners:[ImageBanner]) {
        raceBanners = banners
    }

    var raceBanners = [ImageBanner]()
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return raceBanners.count
    }
    
    func cellIdentifier() -> String {
        return "BannerCollectionViewCell"
    }
    
    func imageUrl(at indexPath: IndexPath) ->  String {
        let imageBanner = raceBanners[indexPath.row]
        return imageBanner.imageUrl
    }
    
    mutating func updateImageBanner(newBanners: [ImageBanner]) -> Bool {
        var oldBanners = [ImageBanner]()
        oldBanners = raceBanners
        let dataChanged = oldBanners != newBanners
        if dataChanged {
            raceBanners = newBanners
        }
        return dataChanged
    }
    
}
