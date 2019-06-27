//
//  GeneralBannerResponse.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import SwiftyJSON

public struct BannerResponse: JsonInitializable, Equatable, DefaultInitializable {

    
    struct PropertyKey {
        static let payload          = "data"
        static let lastUpdateDate   = "last_updated_utc"
        static let banners          = "icon"
        static let tabletBanners    = "banners_tablet"
    }
    
    public let banners: [ImageBanner]

    public init?(_ json: JSON) {
        banners = JSON.parseArray(json, keys: [PropertyKey.payload])
    }
    
    public init() {
        banners = [ImageBanner]()

    }
}


//public struct BannerResponse: Decodable {
//    var banners: [ImageBanner]?
//
//    struct PropertyKey {
//        static let payload          = "data"
//        static let lastUpdateDate   = "last_updated_utc"
//        static let banners          = "icon"
//        static let tabletBanners    = "banners_tablet"
//    }
//    private enum CodingKeys: String, CodingKey {
//        case data = "data"
//    }
//
//    public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        banners = try decoder.decode([ImageBanner].self, from: json)
//
//    }
//}
