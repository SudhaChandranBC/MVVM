//
//  ImageBanner.swift
//  Pods
//
//  Created by Nagumo, Jin on 1/13/16.
//
//
import SwiftyJSON

public class ImageBanner: NSObject, JsonInitializable, DefaultInitializable {

    struct PropertyKey {
        static let imageUrl         = "icon"

    }

    // We put those properties that are representing the same thing but having different names with above existing ones into the left column
    // so we don't parse them again using their original keys, instead, we replace their key with an existing one, and use the same parse
    // logic for existing properties. This is the same process known as "scrubber" in old Ichiba.
    private static let scrubberDictionary =
        [
            "value": "icon",
        ]
    
    public let imageUrl: String

    // MARK: JsonInitializable
    public required init?(_ json: JSON) {
        // Scrub!
        let json: JSON  = JSON.ri_scrub(json, keyMap: ImageBanner.scrubberDictionary)
        imageUrl        = json[PropertyKey.imageUrl].stringValue

        super.init()
    }

    // MARK: DefaultInitializable
    public override required init() {
        imageUrl = ""
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(imageUrl, forKey: PropertyKey.imageUrl)
    }
    
}


//public class ImageBanner: Decodable {
//
//    let iamgeUrl: String?
//
//    private enum CodingKeys: String, CodingKey {
//        case iamgeUrl = "icon"
//    }
//
//    required public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        iamgeUrl = try container.decode(String.self)
//}
