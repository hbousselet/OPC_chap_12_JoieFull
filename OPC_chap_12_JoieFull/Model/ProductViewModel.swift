//
//  ProductViewModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 28/07/2025.
//

import Foundation

struct ProductViewModel: Hashable, Identifiable {
    let id: Int
    let picture: Picture
    let name: String
    let category: ProductCategory
    let likes: Int
    let price: Double
    let originalPrice: Double
    
    struct Picture: Codable, Hashable {
        let url: String
        let description: String
    }

    enum ProductCategory: String, Codable, CaseIterable {
        case accessories = "Accessoires"
        case bottoms = "Bas"
        case shoes = "Chaussures"
        case tops = "Hauts"
    }
}
