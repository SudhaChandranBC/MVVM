//
//  SwiftyJSON_mvvm.swift
//  MVVM
//
//  Created by Chandran, Sudha | SDTD on 27/06/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import SwiftyJSON

public protocol JsonInitializable {
    init?(_ json: JSON)
}

public protocol DefaultInitializable {
    init()
}

public extension JSON {

    static func ri_scrub(_ json: JSON, keyMap: [String: String], overwriteNonNilValue: Bool = false) -> JSON {
        var newJson: JSON = json
        for (oldKey, newKey) in keyMap {
            if json[oldKey] != JSON.null {
                if newJson[newKey] != JSON.null, overwriteNonNilValue == false {
                    // There is already a value assoicated in the new key, and the caller chose not to overwrite it.
                    // We skip this one.
                    continue
                } else {
                    newJson[newKey].object = json[oldKey].object
                    newJson[oldKey] = JSON.null
                }
            }
        }
        return newJson
    }
    
    static func parseArray<T: JsonInitializable>(_ json: JSON, keys: [String]) -> [T] {
        return JSON.getSubJson(json, keys: keys).arrayValue.compactMap() { return T($0) }
    }
    
    private static func getSubJson(_ json: JSON, keys: [String]) -> JSON {
        var subJson: JSON = json
        for key in keys {
            subJson = subJson[key]
        }
        return subJson
    }
    
}
