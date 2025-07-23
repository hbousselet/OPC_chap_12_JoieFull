//
//  ClothesViewModel.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

@Observable final class CothesViewModel: Sendable {
    var products: [Product] = []
    let apiService: ApiService = ApiService()
    
    func fetchProducts() async {
        do {
            let result: [Product] = try await Task.detached {
                try await self.apiService.fetch().get()
            }.value
            
            await MainActor.run {
                self.products = result
            }
        } catch {
            print(error)
        }
    }
}

@Observable class CothesViewModelVariante {
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
