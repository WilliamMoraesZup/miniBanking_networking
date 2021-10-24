//
//  NetworkError.swift
//  miniBanking_networking
//
//  Created by Bruno Vieira on 23/10/21.
//

public protocol ErrorProtocol: Error {
    
    var description: String { get }
    
}

public enum NetworkError: ErrorProtocol {
    
    case unknown
    case unexpected
    case urlNotFound
    case invalidURL
    case invalidRequest
    case invalidRequestBody
    case invalidResponse
    case jsonParse
    case serializationError
    case connectivity
    
    public var description: String {
        get {
            return mapMessage()
        }
    }

    private func mapMessage() -> String {
        switch self {
        case .unknown:
            return "An unknown error has occured. Try again later."
        case .unexpected:
            return "An unexpected error has occured. Check your internet connection and try again."
        case .urlNotFound:
            return "URL not found."
        case .invalidURL:
            return "Invalid URL."
        case .invalidRequest:
            return "Invalid request"
        case .invalidRequestBody:
            return "Invalid request body."
        case .invalidResponse:
            return "Invalid response"
        case .jsonParse:
            return "JSON parsing error."
        case .serializationError:
            return "Object serialization error."
        case .connectivity:
            return "Network connectivity error."
        }
    }
    
}
