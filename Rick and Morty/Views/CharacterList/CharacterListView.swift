//
//  CharacterListView.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    let onSelectCharacter: (Int) -> Void

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Rick & Morty")
                .searchable(text: $viewModel.filter.name, prompt: "Search characters…")
                .toolbar { filterToolbar }
                .onAppear { viewModel.onAppear() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .empty:
            EmptyStateView {
                viewModel.retry(shouldRemoveFilters: true)
            }
        case .error(let message):
            ErrorStateView(message: message) {
                viewModel.retry()
            }
        case .loaded, .loadingMore:
            characterList
        }
    }

    private var characterList: some View {
        List {
            ForEach(viewModel.characters) { character in
                CharacterRowView(character: character)
                    .listRowSeparator(.visible)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .listRowBackground(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelectCharacter(character.id) }
                    .onAppear { viewModel.loadMore(currentItem: character) }
            }

            if case .loadingMore = viewModel.state {
                loadingRow
            }
        }
        .listStyle(.plain)
    }
    
    private var loadingRow: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    @ToolbarContentBuilder
    private var filterToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Status", selection: $viewModel.filter.status) {
                    ForEach(CharacterFilter.StatusFilter.allCases, id: \.self) { status in
                        Text(status.displayName).tag(status)
                    }
                }
            } label: {
                Label("Filter", systemImage: viewModel.filter.status == .all ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
            }
        }
    }
}
