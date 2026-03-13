//
//  Character.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation

nonisolated struct Character: Identifiable, Equatable, Decodable, Sendable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let origin: Location
    let location: Location
    let image: URL?
    let episode: [String]
 
    init(
        id: Int,
        name: String,
        status: CharacterStatus,
        species: String,
        gender: String,
        origin: Location,
        currentLocation: Location,
        imageURL: URL?,
        episodeURLs: [String]
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.origin = origin
        self.location = currentLocation
        self.image = imageURL
        self.episode = episodeURLs
    }
}
 
enum CharacterStatus: String, CaseIterable, Equatable, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
 
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = CharacterStatus(rawValue: raw) ?? .unknown
    }
 
    var displayName: String {
        switch self {
        case .alive:   return "Alive"
        case .dead:    return "Dead"
        case .unknown: return "Unknown"
        }
    }
 
    var color: String {
        switch self {
        case .alive:   return "statusAlive"
        case .dead:    return "statusDead"
        case .unknown: return "statusUnknown"
        }
    }
}
 
nonisolated struct Location: Equatable, Decodable, Sendable {
    let name: String
    let url: String
}
 
nonisolated struct CharacterListResponse: Decodable, Sendable {
    let info: PageInfo
    let results: [Character]
}
 
nonisolated struct CharacterFilter: Equatable, Sendable {
    var name: String = ""
    var status: StatusFilter = .all
 
    enum StatusFilter: String, CaseIterable, Equatable, Sendable {
        case all     = ""
        case alive   = "alive"
        case dead    = "dead"
        case unknown = "unknown"
 
        var displayName: String {
            switch self {
            case .all:     return "All"
            case .alive:   return "Alive"
            case .dead:    return "Dead"
            case .unknown: return "Unknown"
            }
        }
    }
}
 
nonisolated struct PaginatedResult<T: Sendable>: Sendable {
    let items: [T]
    let info: PageInfo
}
 
nonisolated struct PageInfo: Equatable, Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
 
    var hasNextPage: Bool { next != nil }
}
