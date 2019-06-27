//
//  HomeDataProvider.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

public class BannerDataProvider: DataProvider {
    public typealias BannerResponseHandler = ((_ data: BannerResponse, _ error: APIError?) -> Void)

    func loadRaceBanner(completion: @escaping BannerResponseHandler) {
        var raceResponse = BannerResponse()
        var apiError: APIError? = nil
        let raceApi = APIAppEngine.GeneralBanner()
        
        self.apiClient.request(raceApi) {
            response in
            switch response {
            case .success(let result):
                raceResponse = result
            case .failure(let error):
                apiError = error
            }
            completion(raceResponse, apiError)
        }
    }
    
}
