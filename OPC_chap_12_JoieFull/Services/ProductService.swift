//
//  ProductService.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 28/07/2025.
//

import Foundation

protocol ProductServiceLogic {
    func fetch() async throws -> [ProductViewModel]
}

actor ProductService: ProductServiceLogic {
    let apiService: ApiService = ApiService()
    
    func fetch() async throws -> [ProductViewModel] {
        let products: [Product] = try await apiService.fetch().get()
        return convert(products)
    }
    
    private func convert(_ products: [Product]) -> [ProductViewModel] {
        products.compactMap { product in
            ProductViewModel(id: product.id,
                             picture: turn(picture: product.picture),
                             name: product.name,
                             category: turn(category: product.category),
                             likes: product.likes,
                             price: product.price,
                             originalPrice: product.originalPrice)
        }
    }
    
    private func turn(picture: Picture) -> ProductViewModel.Picture {
        return ProductViewModel.Picture(url: picture.url, description: picture.description)
    }
    
    private func turn(category: Category) -> ProductViewModel.ProductCategory {
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
