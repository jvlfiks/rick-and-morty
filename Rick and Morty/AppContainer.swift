//
//  AppContainer.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation

final class AppContainer {
    // MARK: Core
    let logger: LoggerProtocol
    let networkClient: NetworkClientProtocol

    // MARK: Repositories
    let characterRepository: CharacterRepositoryProtocol

    // MARK: Use Cases
    let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    let fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol

    init() {
        self.logger = ConsoleLogger()

        self.networkClient = URLSessionNetworkClient(
            session: .shared,
            logger: logger
        )

        self.characterRepository = CharacterRepository(
            client: networkClient
        )

        self.fetchCharactersUseCase = FetchCharactersUseCase(
            repository: characterRepository
        )

        self.fetchCharacterDetailUseCase = FetchCharacterDetailUseCase(
            repository: characterRepository
        )
    }

    // MARK: - Factory Methods

    func makeCharacterListViewModel() -> CharacterListViewModel {
        CharacterListViewModel(fetchCharactersUseCase: fetchCharactersUseCase)
    }

    func makeCharacterDetailViewModel(characterId: Int) -> CharacterDetailViewModel {
        CharacterDetailViewModel(
            characterId: characterId,
            fetchCharacterDetailUseCase: fetchCharacterDetailUseCase
        )
    }
}
