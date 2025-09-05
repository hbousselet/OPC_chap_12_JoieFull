//
//  ClothesViewModelTests.swift
//  OPC_chap_12_JoieFullTests
//
//  Created by Hugues BOUSSELET on 05/09/2025.
//

import XCTest
@testable import OPC_chap_12_JoieFull

@MainActor
final class ClothesViewModelTests: XCTestCase {
    var mockApi: MockAPIService<[ProductResponseModel]>!
//    var apiWithEmptyResponseType: MockAPIService<EmptyResponse>!

    override func setUpWithError() throws {
        mockApi = MockAPIService()
//        apiWithEmptyResponseType = MockAPIService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchProductOk() async throws {
        let productsJson = """
            [
              {
                "id": 0,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                  "description": "Sac à main orange posé sur une poignée de porte"
                },
                "name": "Sac à main orange",
                "category": "ACCESSORIES",
                "likes": 56,
                "price": 69.99,
                "original_price": 69.99
              },
              {
                "id": 1,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                  "description": "Modèle femme qui porte un jean et un haut jaune"
                },
                "name": "Jean pour femme",
                "category": "BOTTOMS",
                "likes": 55,
                "price": 49.99,
                "original_price": 59.99
              }
            ]
            """.data(using: .utf8)!
        
        guard let products = try? JSONDecoder().decode([ProductResponseModel].self, from: productsJson) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        mockApi.data = products
        mockApi.error = nil
        mockApi.shouldSuccess = true
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        
        await clothesViewModel.fetchProducts()
        
        XCTAssertTrue(clothesViewModel.products.first!.name == "Sac à main orange")
        XCTAssertTrue(clothesViewModel.products[1].name == "Jean pour femme")
    }
    
    func testFetchProductNOKWrongUrl() async throws {
        mockApi.data = nil
        mockApi.error = .wrongURL
        mockApi.shouldSuccess = false
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        
        await clothesViewModel.fetchProducts()
        
        XCTAssert(clothesViewModel.apiError == .wrongURL)
    }
    
    func testFetchProductNOKInvalidStatusCode() async throws {
        mockApi.data = nil
        mockApi.error = .invalidStatusCode(statusCode: 300)
        mockApi.shouldSuccess = false
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        
        await clothesViewModel.fetchProducts()
        
        XCTAssert(clothesViewModel.apiError == .invalidStatusCode(statusCode: 300))
    }
    
    func testFetchProductNOKDecodingError() async throws {
        mockApi.data = nil
        mockApi.error = .decodingError(decodingError: "Decoding error")
        mockApi.shouldSuccess = false
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        
        await clothesViewModel.fetchProducts()
        
        XCTAssert(clothesViewModel.apiError == .decodingError(decodingError: "Decoding error"))
    }
    
    func testFetchProductNOKOtherError() async throws {
        mockApi.data = nil
        mockApi.error = .other(error: "error")
        mockApi.shouldSuccess = false
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        
        await clothesViewModel.fetchProducts()
        
        XCTAssert(clothesViewModel.apiError == .other(error: "error"))
    }
    
    func testToggleIsLikedOk() async {
        let productsJson = """
            [
              {
                "id": 0,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                  "description": "Sac à main orange posé sur une poignée de porte"
                },
                "name": "Sac à main orange",
                "category": "ACCESSORIES",
                "likes": 56,
                "price": 69.99,
                "original_price": 69.99
              },
              {
                "id": 1,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                  "description": "Modèle femme qui porte un jean et un haut jaune"
                },
                "name": "Jean pour femme",
                "category": "BOTTOMS",
                "likes": 55,
                "price": 49.99,
                "original_price": 59.99
              }
            ]
            """.data(using: .utf8)!
        
        guard let products = try? JSONDecoder().decode([ProductResponseModel].self, from: productsJson) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        mockApi.data = products
        mockApi.error = nil
        mockApi.shouldSuccess = true
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        await clothesViewModel.fetchProducts()
        let firstClothe = clothesViewModel.products[0]
        
        XCTAssert(firstClothe.isLiked == false)
        
        clothesViewModel.toggleIsLiked(for: firstClothe)
        
        XCTAssert(clothesViewModel.products[0].isLiked == true)
    }
    
    func testToggleRemoveLikeOk() async {
        let productsJson = """
            [
              {
                "id": 0,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                  "description": "Sac à main orange posé sur une poignée de porte"
                },
                "name": "Sac à main orange",
                "category": "ACCESSORIES",
                "likes": 55,
                "price": 69.99,
                "original_price": 69.99
              },
              {
                "id": 1,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                  "description": "Modèle femme qui porte un jean et un haut jaune"
                },
                "name": "Jean pour femme",
                "category": "BOTTOMS",
                "likes": 87,
                "price": 49.99,
                "original_price": 59.99
              }
            ]
            """.data(using: .utf8)!
        
        guard let products = try? JSONDecoder().decode([ProductResponseModel].self, from: productsJson) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        mockApi.data = products
        mockApi.error = nil
        mockApi.shouldSuccess = true
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        await clothesViewModel.fetchProducts()
        let firstClothe = clothesViewModel.products[0]
        
        XCTAssert(firstClothe.likes == 55)
        
        clothesViewModel.removeLike(for: firstClothe)
        
        XCTAssert(clothesViewModel.products[0].likes == 54)
    }
    
    func testToggleAddLikeOk() async {
        let productsJson = """
            [
              {
                "id": 0,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
                  "description": "Sac à main orange posé sur une poignée de porte"
                },
                "name": "Sac à main orange",
                "category": "ACCESSORIES",
                "likes": 55,
                "price": 69.99,
                "original_price": 69.99
              },
              {
                "id": 1,
                "picture": {
                  "url": "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                  "description": "Modèle femme qui porte un jean et un haut jaune"
                },
                "name": "Jean pour femme",
                "category": "BOTTOMS",
                "likes": 89,
                "price": 49.99,
                "original_price": 59.99
              }
            ]
            """.data(using: .utf8)!
        
        guard let products = try? JSONDecoder().decode([ProductResponseModel].self, from: productsJson) else {
            XCTFail("Not able to decode this json")
            return
        }
        
        mockApi.data = products
        mockApi.error = nil
        mockApi.shouldSuccess = true
        
        let clothesViewModel = ClothesViewModel(serviceApi: mockApi)
        await clothesViewModel.fetchProducts()
        let firstClothe = clothesViewModel.products[0]
        
        XCTAssert(firstClothe.likes == 55)
        
        clothesViewModel.addLike(for: firstClothe)
        
        XCTAssert(clothesViewModel.products[0].likes == 56)
    }

}

class MockAPIService<D: Codable>: ApiServiceInterface {
    var data: D?
    var error: JoieFullError?
    var shouldSuccess: Bool = true
    
    func fetch<T>() async throws -> Result<T, OPC_chap_12_JoieFull.JoieFullError> where T : Decodable, T : Sendable {
        if shouldSuccess {
            return .success(data as! T)
        } else {
            return .failure(error!)
        }
    }
}
