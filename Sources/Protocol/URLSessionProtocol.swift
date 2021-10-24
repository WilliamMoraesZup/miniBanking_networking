//
//  URLSessionProtocol.swift
//  miniBanking_networking
//
//  Created by Bruno Vieira on 23/10/21.
//

import Foundation

public protocol URLSessionProtocol {
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
    
}

extension URLSession: URLSessionProtocol {}
