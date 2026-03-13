//
//  Rick_and_MortyApp.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import SwiftUI

@main
struct Rick_and_MortyApp: App {
    private let container = AppContainer()
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(container: container)
        }
    }
}

struct AppCoordinatorView: View {
    let container: AppContainer
    @State private var path = NavigationPath()
    @StateObject private var listViewModel: CharacterListViewModel

    init(container: AppContainer) {
        self.container = container
        _listViewModel = StateObject(wrappedValue: container.makeCharacterListViewModel())
    }

    var body: some View {
        NavigationStack(path: $path) {
            CharacterListView(
                viewModel: listViewModel,
                onSelectCharacter: { id in path.append(id) }
            )
            .navigationDestination(for: Int.self) { characterId in
                CharacterDetailView(
                    viewModel: container.makeCharacterDetailViewModel(characterId: characterId)
                )
            }
        }
    }
}
