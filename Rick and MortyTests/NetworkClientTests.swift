//
//  NetworkClientTests.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 13/03/26.
//

import XCTest
@testable import Rick_and_Morty

@MainActor
final class NetworkClientTests: XCTestCase {
 
    func test_fetch_decodesCharacterSuccessfully() async throws {
        let client = MockNetworkClient()
        let json = """
        {
          "id": 1,
          "name": "Rick Sanchez",
          "status": "Alive",
          "species": "Human",
          "gender": "Male",
          "origin": { "name": "Earth", "url": "" },
          "location": { "name": "Earth C-137", "url": "" },
          "image": "https://example.com/rick.jpg",
          "episode": ["https://rickandmortyapi.com/api/episode/1"]
        }
        """
        client.result = .success(json.data(using: .utf8)!)
        let request = URLRequest(url: URL(string: "https://example.com")!)
 
        let character = try await client.fetch(Character.self, from: request)
 
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, .alive)
        XCTAssertEqual(character.episode.count, 1)
        XCTAssertEqual(character.location.name, "Earth C-137")
        XCTAssertEqual(character.image?.absoluteString, "https://example.com/rick.jpg")
    }
 
    func test_fetch_throwsDecodingError_forInvalidJSON() async throws {
        let client = MockNetworkClient()
        client.result = .success("not json".data(using: .utf8)!)
        let request = URLRequest(url: URL(string: "https://example.com")!)
 
        do {
            _ = try await client.fetch(Character.self, from: request)
            XCTFail("Should have thrown")
        } catch {
            XCTAssertTrue(error is DecodingError, "Expected DecodingError, got \(error)")
        }
    }
}
