//
//  MockNetworkClient.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 13/03/26.
//

import XCTest
@testable import Rick_and_Morty

final class MockNetworkClient: NetworkClientProtocol {
    var result: Result<Data, Error>?
 
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        guard let result else { throw APIError.unknown }
        let data = try result.get()
        return try JSONDecoder().decode(T.self, from: data)
    }
}
