//
//  ClothesViewModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

@MainActor
@Observable final class ClothesViewModel {
    private(set) var products: [Product] = []
    private let productService: ProductService = ProductService()
    
    var groupedProducts: [String: [Product]] {
        return Dictionary(grouping: products) { $0.category.rawValue }
    }
    
    func fetchProducts() async {
        do {
            products = try await productService.fetch()
        } catch {
            print(error)
        }
    }
    
    func toggleIsLiked(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].toggleLike()
    }
}
