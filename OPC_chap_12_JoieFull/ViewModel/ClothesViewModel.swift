//
//  ClothesViewModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

@Observable final class ClothesViewModel: Sendable {
    var products: [Product] = []
    let apiService: ApiService = ApiService()
    
    var accessories: [Product] {
        products.filter { $0.category == .accessories }
    }
    
    var groupedProducts: [String: [Product]] {
        Dictionary(grouping: products) { $0.category.rawValue }
    }
    
    var bottoms: [Product] {
        products.filter { $0.category == .bottoms }
    }
    
    var shoes: [Product] {
        products.filter { $0.category == .shoes }
    }
    
    var tops: [Product] {
        products.filter { $0.category == .tops }
    }
    
    func fetchProducts() async {
        do {
            let result: [Product] = try await self.apiService.fetch().get()
            
            await MainActor.run {
                self.products = result
            }
        } catch {
            print(error)
        }
    }
}

@MainActor
@Observable class CothesViewModelVariance: Sendable {
    var products: [Product] = []
    let apiService: ApiService = ApiService()
    
    func fetchProducts() async {
        do {
            let result: [Product] = try await apiService.fetch().get()
            products = result
        } catch {
            print(error)
        }
    }
}
