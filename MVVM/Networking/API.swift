//
//  Host.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

public protocol API {
    associatedtype ResponseType: Decodable
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get set }
    var headers: Dictionary<String, String> { get set }
    var encode: APIEncode { get }
    var encodeOption: APIEncodeOption { get }
}

public extension API {
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: [String: Any] {
        return [String: Any]()
    }
    
    var headers: [String: String] {
        return [String: String]()
    }
    
    var encode: APIEncode {
        return .url
    }
    
    var encodeOption: APIEncodeOption {
        return .urlQueryAllowed
    }
    
    var parameterJsonData: Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
    
    var parameterStringExpression: String {
        return APIAppEngine.encodeGET(parameters: parameters,
                                     option: encodeOption)
    }
    
    var parameterQueryData: Data? {
        return parameterStringExpression.data(using: .utf8)
    }
    
    func printDebugInformation() {
        debugPrint(self.path)
        debugPrint(self.parameters)
        debugPrint(self.method.rawValue)
        debugPrint(self.headers)
    }
}



public enum APIEndPoint: String {
    case bannerList           = "sp/inc/output/app/pointpartner_appli_information_iOS.json"
    
    public static var EventGateHostUrl: String {
        return "http://pointcard.rakuten.co.jp/"
    }
    
    public static var AppEngineBaseUrl: String {
        return EventGateHostUrl + "api/"
    }
    
    var urlString: String {
        return APIEndPoint.EventGateHostUrl + self.rawValue
    }
}

public struct APIAppEngine {
    
    fileprivate struct EGAppEngineConstant {
        static let ostype           = "ios"
        static let device_type      = "ios"
        static let xAppKey          = "x-app-key"
    }
    
    public struct Configuration {
        static let TutorialDidShown = "EG_tutorialDidShown"
        static let RemoteNotificationSystemPopupDidShow = "EG_RemoteNotificationSystemPopupDidShow"
        static let DeviceToken = "EG_device_token"
        static let AppVersion = "EG_app_version"
        static let RecievableTickets = "EG_RecievableTickets"
    }
    
    static let host: String = APIEndPoint.EventGateHostUrl
    public static let version: String = Configuration.AppVersion
    
    public static func encodeGET(firstOptionalURLParameter: [String: Any]? = nil, parameters: [String: Any], nonKeyValueParameters: Set<String>? = nil, option: APIEncodeOption = .urlQueryAllowed) -> String {
        /*
         encodeOption: .urlQueryAllowed
         - parameters and nonKeyValueParameters will be encoded except 'urlQueryAllowed'
         
         encodeOption: .all
         - parameters will be encoded without exception character, while nonKeyValueParameters with be encoded except urlQueryAllowed and "+
         */
        var stringVale = ""
        if let firstOptionalURLParameter = firstOptionalURLParameter {
            for (key, value) in firstOptionalURLParameter {
                var paramValue = String(describing: value)
                if option == .all {
                    paramValue = paramValue.addingPercentEncoding(withAllowedCharacters: CharacterSet()) ?? ""
                }
                stringVale = stringVale + key + "=" + paramValue + "&"
            }
        }
        
        for (key, value) in parameters {
            var paramValue = String(describing: value)
            if option == .all {
                paramValue = paramValue.addingPercentEncoding(withAllowedCharacters: CharacterSet()) ?? ""
            }
            stringVale = stringVale + key + "=" + paramValue + "&"
        }
        
        var flattenedNonKeyValueParameters = ""
        if let oParams = nonKeyValueParameters {
            for param in oParams {
                flattenedNonKeyValueParameters = flattenedNonKeyValueParameters + param
            }
        }
        
        if flattenedNonKeyValueParameters.isEmpty {
            stringVale = String(stringVale.dropLast())
        }
        
        var parametersThatNeedEncoding = ""
        if option == .urlQueryAllowed {
            parametersThatNeedEncoding = stringVale + flattenedNonKeyValueParameters
        } else {
            parametersThatNeedEncoding = flattenedNonKeyValueParameters
        }
        /*
         url encode
         Space       ->       +
         +           ->       %2B
         
         NSCharacterSet.urlQueryAllowed contains '+' so that will not encoded
         */
        var urlQueryAllowed = NSCharacterSet.urlQueryAllowed
        urlQueryAllowed.remove(charactersIn: "+")
        if let encodedString = parametersThatNeedEncoding.addingPercentEncoding(withAllowedCharacters: urlQueryAllowed) {
            if encodedString.count > 0 {
                parametersThatNeedEncoding = encodedString
            }
        }
        
        if option == .all {
            return stringVale + parametersThatNeedEncoding
        } else {
            return parametersThatNeedEncoding
        }
    }
}



public enum APIEncodeOption {
    case urlQueryAllowed, all
}

public enum APIEncode {
    case url, json
}

public struct Configuration {
    
        public struct Development {
            static let EndPointType = "DEV_EndPointType"
        }
        
        public struct EventGate {
            static let TutorialDidShown = "EG_tutorialDidShown"
            static let RemoteNotificationSystemPopupDidShow = "EG_RemoteNotificationSystemPopupDidShow"
            static let DeviceToken = "EG_device_token"
            static let AppVersion = "EG_app_version"
            static let RecievableTickets = "EG_RecievableTickets"
        }

}



public enum Response<T, U>: Equatable {
    case success(T)
    case failure(U)
    
    public static func ==<T, U>(lhs: Response<T, U>, rhs: Response<T, U>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lvalue), .success(let rvalue)):
            return isEqual(lhs: lvalue, rhs: rvalue)
        case (.failure(let lvalue), .failure(let rvalue)):
            return isEqual(lhs: lvalue, rhs: rvalue)
        default:
            return false
        }
    }
    
    private static func isEqual<V>(lhs: V, rhs: V) -> Bool {
        if type(of: lhs) == type(of: rhs) {
            if let lValue = lhs as? String, let rValue = rhs as? String {
                return lValue == rValue
            }
            if let lValue = lhs as? Int, let rValue = rhs as? Int {
                return lValue == rValue
            }
            return false
        }
        return false
    }
}

public enum APIError: Error {
    case httpError(Int)
    case invalidJson(String)
    case authenticationError(String)
    case mockDataNotAvailable
    case mockDataNotFound(String)
    case offline
    case timeout
    case unknown

    var ErrorDescription: String {
        switch self {
        case .offline:
            return "EG.Error.Offline"
        case .timeout:
            return "EG.Error.Timeout"
        default:
            return "EG.Error.APIError"
        }
    }
}
