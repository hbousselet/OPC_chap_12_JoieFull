//
//  ClothesViewModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

// si class flag en MainActor alors il est Sendable + Attention, viewModel toujours sous MainActor !
@MainActor
@Observable final class ClothesViewModel {
    var products: [ProductViewModel] = []
    let productService: ProductService = ProductService()
    
    var groupedProducts: [String: [ProductViewModel]] {
        return Dictionary(grouping: products) { $0.category.rawValue }
    }
    
    func fetchProducts() async {
        do {
            products = try await productService.fetch()
        } catch {
            print(error)
        }
    }
}
