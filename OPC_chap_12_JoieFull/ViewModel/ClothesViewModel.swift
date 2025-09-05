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
    private let productService: ProductService
    var apiError: JoieFullError?
    
    var groupedProducts: [String: [Product]] {
        return Dictionary(grouping: products) { $0.category.rawValue }
    }
        
    init(serviceApi: ApiServiceInterface) {
        self.productService = ProductService(apiService: serviceApi)
    }
    
    func fetchProducts() async {
        do {
            products = try await productService.fetch()
        } catch {
            apiError = error as? JoieFullError
        }
    }
    
    func toggleIsLiked(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].toggleLike()
    }
    
    func removeLike(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].removeALike()
    }
    
    func addLike(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index].addALike()
    }
}
