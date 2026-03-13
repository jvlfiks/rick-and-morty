//
//  CharacterListViewModel.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case loadingMore
        case empty
        case error(String)
    }

    @Published private(set) var characters: [Character] = []
    @Published private(set) var state: ViewState = .idle
    @Published var filter: CharacterFilter = CharacterFilter()

    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private var currentPage = 1
    private var hasNextPage = true
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(fetchCharactersUseCase: FetchCharactersUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
        bindFilter()
    }

    func onAppear() {
        guard state == .idle else { return }
        loadFirstPage()
    }

    func loadMore(currentItem item: Character) {
        guard case .loaded = state,
              hasNextPage,
              shouldLoadMore(for: item) else { return }
        loadNextPage()
    }

    func retry(shouldRemoveFilters: Bool = false) {
        if shouldRemoveFilters {
            filter = CharacterFilter()
        }
        loadFirstPage()
    }

    private func bindFilter() {
        $filter
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.loadFirstPage()
            }
            .store(in: &cancellables)
    }

    private func loadFirstPage() {
        searchTask?.cancel()
        searchTask = Task {
            currentPage = 1
            hasNextPage = true
            characters = []
            state = .loading

            await fetchPage(page: 1, appending: false)
        }
    }

    private func loadNextPage() {
        guard !Task.isCancelled else { return }
        state = .loadingMore
        let nextPage = currentPage + 1
        Task {
            await fetchPage(page: nextPage, appending: true)
        }
    }

    private func fetchPage(page: Int, appending: Bool) async {
        do {
            let result = try await fetchCharactersUseCase.execute(page: page, filter: filter)

            guard !Task.isCancelled else { return }

            if appending {
                characters.append(contentsOf: result.items)
            } else {
                characters = result.items
            }

            currentPage = page
            hasNextPage = result.info.hasNextPage
            state = characters.isEmpty ? .empty : .loaded
        } catch {
            guard !Task.isCancelled else { return }
            state = .error(error.localizedDescription)
        }
    }

    private func shouldLoadMore(for item: Character) -> Bool {
        guard let last = characters.last else { return false }
        return item.id == last.id
    }
}
