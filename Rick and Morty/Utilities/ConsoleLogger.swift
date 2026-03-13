//
//  ConsoleLogger.swift
//  Rick and Morty
//
//  Created by João Vitor Loureiro Fiks on 13/03/26.
//

final class ConsoleLogger: LoggerProtocol {
    func log(_ message: String, level: LogLevel) {
        #if DEBUG
        let prefix: String
        switch level {
        case .debug:   prefix = "🔍"
        case .info:    prefix = "ℹ️"
        case .warning: prefix = "⚠️"
        case .error:   prefix = "❌"
        }
        print("\(prefix) [RickAndMorty] \(message)")
        #endif
    }
}
