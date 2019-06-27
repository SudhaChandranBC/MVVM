//
//  Main.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

extension APIAppEngine {
    public struct GeneralBanner: API {
        public typealias ResponseType = BannerResponse
        public let path: String = APIEndPoint.bannerList.urlString
        public var headers = Dictionary<String, String>()
        public var parameters = [String: Any]()

    }
}
