//
//  AppError.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation


enum NetworkError: Error {
    case failedParsingData
    case invalidData
    case failedCreatingRequest
    case noInternet
    case badServiceResponse(response: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var description: String {
        switch self {
        case .failedParsingData:
            return "Couldn't parse data"
        case .invalidData:
            return "Couldn't get data"
        case .failedCreatingRequest:
            return "Failed create request"
        case .noInternet:
            return "You have no internet connection, try reload"
        case let .invalidStatusCode(statusCode):
            return "Invalid status code - \(statusCode)"
        case let .badServiceResponse(response):
            return "Bad service response: \(response)"
        case let .unknownError(error):
            return "Error: \(error.localizedDescription)"
            
        }
    }
}
