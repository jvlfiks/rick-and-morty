//
//  CharacterRepository.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation
 
final class CharacterRepository: CharacterRepositoryProtocol {
    private let client: NetworkClientProtocol
    private let baseURL: URL
 
    init(client: NetworkClientProtocol, baseURL: URL = URL(string: "https://rickandmortyapi.com/api")!) {
        self.client = client
        self.baseURL = baseURL
    }
 
    func fetchCharacters(page: Int, filter: CharacterFilter) async throws -> PaginatedResult<Character> {
        do {
            let request = try buildCharacterListRequest(page: page, filter: filter)
            let response: CharacterListResponse = try await client.fetch(CharacterListResponse.self, from: request)
            return PaginatedResult(items: response.results, info: response.info)
        } catch APIError.httpError(404) {
            return PaginatedResult(items: [], info: PageInfo(count: 0, pages: 0, next: nil, prev: nil))
        }
    }
 
    func fetchCharacter(id: Int) async throws -> Character {
        let url = baseURL.appendingPathComponent("character/\(id)")
        return try await client.fetch(Character.self, from: URLRequest(url: url))
    }
 
    private func buildCharacterListRequest(page: Int, filter: CharacterFilter) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent("character"), resolvingAgainstBaseURL: false)!
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "page", value: "\(page)")]
 
        if !filter.name.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: filter.name))
        }
        if filter.status != .all {
            queryItems.append(URLQueryItem(name: "status", value: filter.status.rawValue))
        }
 
        components.queryItems = queryItems
        guard let url = components.url else { throw APIError.invalidURL }
        return URLRequest(url: url)
    }
}
