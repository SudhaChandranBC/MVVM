//
//  ImageBanner.swift
//  Pods
//
//  Created by Nagumo, Jin on 1/13/16.
//
//

public class ImageBanner: Decodable {

    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case imageUrl = "icon"
    }

    required public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        imageUrl = try container.decode(String.self)
    }
}
