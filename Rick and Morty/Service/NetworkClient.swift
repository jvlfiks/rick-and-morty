//
//  NetworkClient.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 11/03/26.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingError
    case networkError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL."
        case .httpError(let code): "Server returned error \(code)."
        case .decodingError: "Failed to parse response."
        case .networkError(let msg): msg
        case .unknown: "An unknown error occurred."
        }
    }
}

final class URLSessionNetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let logger: LoggerProtocol

    init(session: URLSession = .shared, logger: LoggerProtocol) {
        self.session = session
        self.logger = logger
    }

    func fetch<T: Decodable & Sendable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        logger.log("→ \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")", level: .debug)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            logger.log("Network error: \(error.localizedDescription)", level: .error)
            throw APIError.networkError(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse {
            logger.log("← \(http.statusCode)", level: .debug)
            guard (200..<300).contains(http.statusCode) else {
                throw APIError.httpError(statusCode: http.statusCode)
            }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.log("Decoding error: \(error)", level: .error)
            throw APIError.decodingError
        }
    }
}
