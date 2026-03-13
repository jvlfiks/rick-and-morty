//
//  StatusBadgeView.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import SwiftUI

struct StatusBadgeView: View {
    let status: CharacterStatus

    private var color: Color {
        switch status {
        case .alive:   return .green
        case .dead:    return .red
        case .unknown: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(status.displayName)
                .font(.caption.weight(.semibold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }
}
