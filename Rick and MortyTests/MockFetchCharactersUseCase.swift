//
//  MockFetchCharactersUseCase.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 13/03/26.
//

@testable import Rick_and_Morty

final class MockFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    var result: Result<PaginatedResult<Character>, Error> = .success(
        PaginatedResult(items: [], info: PageInfo(count: 0, pages: 0, next: nil, prev: nil))
    )
    private(set) var lastPage: Int?
    private(set) var lastFilter: CharacterFilter?
 
    func execute(page: Int, filter: CharacterFilter) async throws -> PaginatedResult<Character> {
        lastPage = page
        lastFilter = filter
        return try result.get()
    }
}
