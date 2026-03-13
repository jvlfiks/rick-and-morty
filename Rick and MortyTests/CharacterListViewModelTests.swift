//
//  CharacterListViewModelTests.swift
//  Rick and MortyTests
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import XCTest
@testable import Rick_and_Morty
 
@MainActor
final class CharacterListViewModelTests: XCTestCase {
    
    func test_onAppear_loadsCharactersSuccessfully() async throws {
        let useCase = MockFetchCharactersUseCase()
        let characters = [makeCharacter(id: 1), makeCharacter(id: 2)]
        useCase.result = .success(makePaginatedResult(items: characters))
        let sut = CharacterListViewModel(fetchCharactersUseCase: useCase)
        
        sut.onAppear()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.characters.count, 2)
    }
    
    func test_filterChange_resetsToPageOne() async throws {
        let useCase = MockFetchCharactersUseCase()
        useCase.result = .success(makePaginatedResult(items: [makeCharacter()]))
        let sut = CharacterListViewModel(fetchCharactersUseCase: useCase)
        
        sut.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        sut.filter.status = .alive
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(useCase.lastPage, 1, "Filter change should reset to page 1")
        XCTAssertEqual(useCase.lastFilter?.status, .alive)
    }
    
    func test_onAppear_setsErrorStateOnFailure() async throws {
        let useCase = MockFetchCharactersUseCase()
        useCase.result = .failure(APIError.networkError("No connection"))
        let sut = CharacterListViewModel(fetchCharactersUseCase: useCase)
        
        sut.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        if case .error = sut.state { /* pass */ } else {
            XCTFail("Expected error state, got \(sut.state)")
        }
    }
    
    func test_noResults_setsEmptyState() async throws {
        let useCase = MockFetchCharactersUseCase()
        useCase.result = .success(PaginatedResult(
            items: [],
            info: PageInfo(count: 0, pages: 0, next: nil, prev: nil)
        ))
        let sut = CharacterListViewModel(fetchCharactersUseCase: useCase)
        
        sut.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.state, .empty)
        XCTAssertTrue(sut.characters.isEmpty)
    }
}
