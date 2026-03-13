//
//  Protocols.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation

protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int, filter: CharacterFilter) async throws -> PaginatedResult<Character>
    func fetchCharacter(id: Int) async throws -> Character
}

protocol NetworkClientProtocol {
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from request: URLRequest) async throws -> T
}

protocol LoggerProtocol {
    func log(_ message: String, level: LogLevel)
}

enum LogLevel {
    case debug, info, warning, error
}
