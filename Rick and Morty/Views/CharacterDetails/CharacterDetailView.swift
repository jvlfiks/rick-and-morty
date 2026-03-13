//
//  CharacterDetailView.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                LoadingView()
            case .error(let message):
                ErrorStateView(message: message, onRetry: viewModel.retry)
            case .loaded(let character):
                detailContent(character)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func detailContent(_ character: Character) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                AsyncImage(url: character.image) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                    default:
                        ZStack {
                            Color(.systemGray6)
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(character.name)
                            .font(.largeTitle.bold())

                        StatusBadgeView(status: character.status)
                    }

                    Divider()
                    infoGrid(character)
                    Divider()
                    locationSection(character)
                    Divider()
                    episodeSection(character)
                }
                .padding(20)
            }
        }
        .navigationTitle(character.name)
    }

    private func infoGrid(_ character: Character) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Info")
                .font(.title3.bold())

            HStack(spacing: 12) {
                infoCell(title: "Species", value: character.species)
                infoCell(title: "Gender", value: character.gender)
            }
        }
    }

    private func locationSection(_ character: Character) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Locations")
                .font(.title3.bold())

            infoCell(title: "Origin", value: character.origin.name)
            infoCell(title: "Last Known Location", value: character.location.name)
        }
    }

    private func episodeSection(_ character: Character) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Episodes")
                .font(.title3.bold())

            Text("Appears in \(character.episode.count) episode\(character.episode.count == 1 ? "" : "s")")
                .font(.body)
                .foregroundColor(.secondary)

            if !character.episode.isEmpty {
                let previews = character.episode.prefix(5)
                ForEach(Array(previews.enumerated()), id: \.offset) { _, url in
                    let epNumber = url.split(separator: "/").last.map(String.init) ?? url
                    Text("Episode \(epNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if character.episode.count > 5 {
                    Text("+ \(character.episode.count - 5) more…")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func infoCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.body.weight(.medium))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
