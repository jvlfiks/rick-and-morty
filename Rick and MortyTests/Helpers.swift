//
//  Helpers.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 13/03/26.
//

@testable import Rick_and_Morty

func makeCharacter(id: Int = 1, name: String = "Rick") -> Character {
    Character(
        id: id, name: name, status: .alive, species: "Human",
        gender: "Male",
        origin: Location(name: "Earth", url: ""),
        currentLocation: Location(name: "Earth", url: ""),
        imageURL: nil, episodeURLs: []
    )
}
 
func makePaginatedResult(
    items: [Character] = [],
    hasNext: Bool = false
) -> PaginatedResult<Character> {
    PaginatedResult(
        items: items,
        info: PageInfo(count: items.count, pages: 1, next: hasNext ? "next" : nil, prev: nil)
    )
}
