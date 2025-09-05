//
//  ProductService.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 28/07/2025.
//

import Foundation

protocol ProductServiceLogic {
    func fetch() async throws -> [Product]
}

actor ProductService: ProductServiceLogic {
    var apiService: ApiServiceInterface
    
    init(apiService: ApiServiceInterface) {
        self.apiService = apiService
    }
    
    func fetch() async throws -> [Product] {
        let products: [ProductResponseModel] = try await apiService.fetch().get()
        return convert(products)
    }
    
    private func convert(_ products: [ProductResponseModel]) -> [Product] {
        products.compactMap { product in
            Product(id: product.id,
                             picture: turn(picture: product.picture),
                             name: product.name,
                             category: turn(category: product.category),
                             likes: product.likes,
                             price: product.price,
                             originalPrice: product.originalPrice,
                             isLiked: false,
                             evaluation: Double.random(in: 0.1...5.0),
                    accessibilityLabel: "Nom du produit \(product.name), qui coûte \(String(product.price)) et qui a pour description \(product.picture.description)")
        }
    }
    
    private func turn(picture: Picture) -> Product.Picture {
        return Product.Picture(url: picture.url, description: picture.description)
    }
    
    private func turn(category: Category) -> Product.ProductCategory {
        switch category {
        case .accessories:
            return .accessories
        case .bottoms:
            return .bottoms
        case .tops:
            return .tops
        case .shoes:
            return .shoes
        }
    }
}
