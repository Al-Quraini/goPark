//
//  NetworkError.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import Foundation

enum APINetworkError: Error, LocalizedError {
    case badURL
    case badResponse(Int)
    case other(Error)
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Bad url"
        case .badResponse(let statusCode):
            return "bad response \(statusCode)"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
