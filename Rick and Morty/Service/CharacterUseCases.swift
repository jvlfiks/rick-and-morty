//
//  CharacterUseCases.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation

protocol FetchCharactersUseCaseProtocol {
    func execute(page: Int, filter: CharacterFilter) async throws -> PaginatedResult<Character>
}

struct FetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, filter: CharacterFilter) async throws -> PaginatedResult<Character> {
        try await repository.fetchCharacters(page: page, filter: filter)
    }
}

protocol FetchCharacterDetailUseCaseProtocol {
    func execute(id: Int) async throws -> Character
}

struct FetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol

    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Character {
        try await repository.fetchCharacter(id: id)
    }
}
