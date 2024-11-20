//
//  SwipeModel.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import Foundation

struct SwipeModel: Hashable, Codable {
    let image: String?
    let price: Double
    let product_name: String
    let product_type: String
    let tax: Double
    
    enum CodingKeys: String, CodingKey { case image, price, product_name, product_type, tax }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(price, forKey: .price)
        try container.encode(product_name, forKey: .product_name)
        try container.encode(product_type, forKey: .product_type)
        try container.encode(tax, forKey: .tax)
    }
}

struct PostSwipeModel: Hashable, Codable {
    let message: String
    let product_details: SwipeModel?
    let product_id: Int
    let success: Bool
}

struct FavoriteProduct: Identifiable {
    let id: UUID
    var product: SwipeModel
    var isFavorite: Bool
}


