//
//  CharacterDetailViewModel.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {

    enum ViewState: Equatable {
        case loading
        case loaded(Character)
        case error(String)
    }

    @Published private(set) var state: ViewState = .loading

    private let characterId: Int
    private let fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol

    init(characterId: Int, fetchCharacterDetailUseCase: FetchCharacterDetailUseCaseProtocol) {
        self.characterId = characterId
        self.fetchCharacterDetailUseCase = fetchCharacterDetailUseCase
    }

    func onAppear() {
        Task { await load() }
    }

    func retry() {
        state = .loading
        Task { await load() }
    }

    func load() async {
        do {
            let character = try await fetchCharacterDetailUseCase.execute(id: characterId)
            state = .loaded(character)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
