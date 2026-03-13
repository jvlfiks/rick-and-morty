//
//  CharacterRowView.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character

    var body: some View {
        HStack(spacing: 16) {
            characterImage
            characterInfoStack
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .background(Color(.secondarySystemGroupedBackground))
    }
    
    private var characterImage: some View {
        AsyncImage(url: character.image) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            default:
                ProgressView()
            }
        }
        .frame(width: 72, height: 72)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var characterInfoStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character.name)
                .font(.headline)
                .lineLimit(1)

            StatusBadgeView(status: character.status)

            Text(character.species)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
