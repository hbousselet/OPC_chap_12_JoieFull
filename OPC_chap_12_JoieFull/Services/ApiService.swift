//
//  ApiService.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import Foundation

protocol ApiServiceInterface: Sendable {
    func fetch<T: DecodableSendable>() async throws -> Result<T, JoieFullError>
}

typealias DecodableSendable = Sendable & Decodable

final class ApiService: ApiServiceInterface {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: DecodableSendable>() async throws -> Result<T, JoieFullError> {
        do {
            guard let url = URL.clothes else { return .failure(.wrongURL) }
            let (data, response) = try await session.data(from: url)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw JoieFullError.invalidStatusCode(statusCode: -1)
            }
            
            guard (200...299).contains(statusCode) else {
                throw JoieFullError.invalidStatusCode(statusCode: statusCode)
            }
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch let error as DecodingError {
            throw JoieFullError.decodingError(decodingError: "Decoding error")
        } catch {
            throw JoieFullError.other(error: error.localizedDescription)
        }
    }
}
    
extension URL {
    static let clothes = URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")
}

enum JoieFullError: Equatable, Error {
    case wrongURL
    case invalidStatusCode(statusCode: Int)
    case decodingError(decodingError: String)
    case other(error: String)
    
    static func == (lhs: JoieFullError, rhs: JoieFullError) -> Bool {
        switch (lhs, rhs) {
        case (.wrongURL, .wrongURL):
            return true
        case (.invalidStatusCode(let lhsStatusCode), .invalidStatusCode(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.description == rhsError.description
        case (.other(let lhsError), .other(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
