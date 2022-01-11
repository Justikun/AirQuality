//
//  NetworkError.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Bad URL: Unable to reach server"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server returned with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data"
        }
    }
} // End of enum
