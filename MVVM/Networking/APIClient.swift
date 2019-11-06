//
//  APIClient.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 26/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
}

public class APIClient: NSObject {

    private var alamofireManager = Alamofire.SessionManager()
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constant.timeoutInterval
        
        let headers: HTTPHeaders = [
            "Accept": Constant.accept
        ]
        configuration.httpAdditionalHeaders = headers
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    private struct Constant {
        static let timeoutInterval = 10.0
        static let cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData
        static let accept = "application/json"
        static let submit = "submit"
        static let success = "success"
        static let result = "result"
    }
    
    private func composeRequest<T: API>(with api: T) -> URLRequest? {
        api.printDebugInformation()
        
        var urlString = api.path
        if api.method == .GET {
            urlString += "?" + api.parameterStringExpression
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: Constant.cachePolicy, timeoutInterval: Constant.timeoutInterval)
        request.httpMethod = api.method.rawValue
        
        if api.method == .POST {
            if api.encode == .url {
                request.httpBody = api.parameterQueryData
            } else {
                request.httpBody = api.parameterJsonData
            }
        }
        
        for (field, value) in api.headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        return request
    }
    private func getAPIError(_ error: Error?) -> APIError {
        var apiError = APIError.unknown
        if let error = error as NSError? {
            if error.code == -1001 {
                // Time out
                apiError = .timeout
            } else if error.code == -1009 {
                // offline
                apiError = .offline
            } else {
                apiError = .httpError(error.code)
            }
        }
        return apiError
    }

    public func request<T: API>(_ api: T, completion:@escaping (Response<T.ResponseType, APIError>) -> Void) {
        
        let globalQueue = DispatchQueue.global(qos: .userInteractive)
        if let request = self.composeRequest(with: api) {
            alamofireManager
                .request(request)
                .responseJSON(queue: globalQueue) { (response) in
                    //                    debugPrint(response)
                    DispatchQueue.main.async {
                        switch(response.result) {
                        case .success(let json):
                            let decoder = JSONDecoder()
//                            let products = try decoder.decode([GroceryProduct].self, from: json)
                            
                            let jsonVal = JSON(json)
                            
                            if jsonVal[Constant.submit] == true,
                                jsonVal[Constant.success] == true {
                                self.processResponse(with: api, jsonValue: jsonVal[Constant.result] as JSON, completion: completion)
                            } else {
                                self.processResponse(with: api, jsonValue: jsonVal as JSON, completion: completion)
                            }
                            
                            break
                        case .failure(let error):
                            completion(Response.failure(self.getAPIError(error)))
                            break
                        }
                    }
            }
        }
        
    }

    
    private func processResponse<T: API>(with api: T, jsonValue: JSON, completion: (Response<T.ResponseType, APIError>) -> Void) {
        var res: Response<T.ResponseType, APIError>
        
        if let t: T.ResponseType = T.ResponseType(jsonValue) {
            // api.saveCache(jsonValue)
            res = Response.success(t)
        } else {
            res = .failure(APIError.invalidJson("Response JSON can not be parsed"))
        }
        completion(res)
    }
    
    
}

