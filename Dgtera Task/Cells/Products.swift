//
//  Products.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
struct ProductsModel: Codable {
    var jsonrpc: String?
    var id: Int?
    var result: [Products]?
}

struct Products: Codable, Equatable {
    var id, orderViewCount: Int?
    var displayName: String?
    var lstPrice: Double?
    var imageSmall: ImageSmall?
    var originalName: String?
    var nameAr: Bool?
    var otherLangName: String?
    var productVariantIDS: [Int]?
    var sequence: Int?

    enum CodingKeys: String, CodingKey {
        case id, orderViewCount
        case displayName = "display_name"
        case lstPrice = "lst_price"
        case imageSmall = "image_small"
        case originalName = "original_name"
        case nameAr = "name_ar"
        case otherLangName = "other_lang_name"
        case productVariantIDS = "product_variant_ids"
        case sequence
    }
    public static func ==(lhs: Products, rhs: Products) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ImageSmall: Codable,Equatable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ImageSmall.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ImageSmall"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    // Computed property to get the string value
    var stringValue: String? {
        switch self {
        case .bool(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}
