//
//  Product.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 28/07/2025.
//

import Foundation
import CoreTransferable

struct Product: Hashable, Identifiable {
    let id: Int
    let picture: Picture
    let name: String
    let category: ProductCategory
    var likes: Int
    let price: Double
    let originalPrice: Double
    var isLiked: Bool
    let evaluation: Double
    
    struct Picture: Codable, Hashable, Transferable {
        static var transferRepresentation: some TransferRepresentation {
            ProxyRepresentation(exporting: \.url)
        }
        let url: String
        let description: String
    }

    enum ProductCategory: String, Codable, CaseIterable {
        case accessories = "Accessoires"
        case bottoms = "Bas"
        case shoes = "Chaussures"
        case tops = "Hauts"
    }
    
    mutating func toggleLike() {
        isLiked.toggle()
    }
    
    mutating func removeALike() {
        if likes > 0 {
            likes -= 1
        }
    }
    
    mutating func addALike() {
        likes += 1
    }
}
