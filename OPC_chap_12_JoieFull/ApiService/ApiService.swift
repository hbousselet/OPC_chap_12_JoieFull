//
//  ApiService.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

protocol ApiServiceProtocol {
    func fetch<T: Decodable>() async throws -> Result<T, Error>
}

class ApiService {
    var session: URLSession = .shared
    
    func fetch<T: Decodable>() async throws -> Result<T, JoieFullError> {
        do {
            guard let url = URL.clothes else { return .failure(.wrongURL) }
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw JoieFullError.invalidStatusCode(statusCode: -1)
            }
            
            guard (200...299).contains(statusCode) else {
                throw JoieFullError.invalidStatusCode(statusCode: statusCode)
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch let error as DecodingError {
            throw JoieFullError.decodingError(decodingError: error)
        } catch {
            throw JoieFullError.other(error: error.localizedDescription)
        }
    }
}
    
extension URL {
    static let clothes = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")
}

enum JoieFullError: Error {
    case wrongURL
    case invalidStatusCode(statusCode: Int)
    case decodingError(decodingError: DecodingError)
    case other(error: String)
}
