//
//  RequestProtocol.swift
//  miniBanking_networking
//
//  Created by Bruno Vieira on 23/10/21.
//

public enum HTTPMethod: String {
    
    case GET
    case POST
    
}

public protocol RequestProtocol {
    
    var endpoint: String { get }
    var method: HTTPMethod { get }
    
    var path: [String]? { get }
    var body: [String: Any]? { get }
    
}

public extension RequestProtocol {
    
    var path: [String]? { nil }
    var body: [String: Any]? { nil }
    
}
