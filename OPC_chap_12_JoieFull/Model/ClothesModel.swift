//
//  ClothesModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

// MARK: - Product
struct Product: Codable, Identifiable {
    let id: Int
    let picture: Picture
    let name: String
    let category: Category
    let likes: Int
    let price: Double
    let originalPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id, picture, name, category, likes, price
        case originalPrice = "original_price"
    }
}

// MARK: - Picture
struct Picture: Codable {
    let url: String
    let description: String
}

// MARK: - Category
enum Category: String, Codable, CaseIterable {
    case accessories = "ACCESSORIES"
    case bottoms = "BOTTOMS"
    case shoes = "SHOES"
    case tops = "TOPS"
}


// MARK: - Exemple d'utilisation
extension Product {
    var isOnSale: Bool {
        return price < originalPrice
    }
    
    var discountPercentage: Int {
        guard originalPrice > price else { return 0 }
        return Int(((originalPrice - price) / originalPrice) * 100)
    }
}
