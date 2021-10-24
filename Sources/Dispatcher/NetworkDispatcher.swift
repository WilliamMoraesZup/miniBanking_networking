//
//  NetworkDispatcher.swift
//  miniBanking_networking
//
//  Created by Bruno Vieira on 23/10/21.
//

import Foundation
import miniBanking_mock

public protocol NetworkDispatcherProtocol {
    
    func requestArray<T: Decodable>(
        of type: T.Type,
        request: RequestProtocol,
        completion: @escaping (Result<[T], NetworkError>) -> Void
    )
    func requestObject<T: Decodable>(
        of type: T.Type,
        request: RequestProtocol,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
}

public final class NetworkDispatcher: NetworkDispatcherProtocol {
    
    // MARK: - Properties
    
    private(set) var session: URLSessionProtocol
    
    // MARK: - Initialization
    
    public required init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func requestArray<T: Decodable>(
        of type: T.Type,
        request: RequestProtocol,
        completion: @escaping (Result<[T], NetworkError>) -> Void
    ) {
        let builtTask = buildTaskRequestFromRequest(request)
        switch builtTask {
        case .success(let task):
            dispatch(request: task) { response in
                switch response {
                case .success(let data):
                    guard let objectResponse = try? JSONDecoder().decode([T].self, from: data) else {
                        completion(.failure(.serializationError))
                        return
                    }
                    completion(.success(objectResponse))
                    return
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    public func requestObject<T: Decodable>(
        of type: T.Type,
        request: RequestProtocol,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let builtTask = buildTaskRequestFromRequest(request)
        switch builtTask {
        case .success(let task):
            dispatch(request: task) { response in
                switch response {
                case .success(let data):
                    guard let objectResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        completion(.failure(.serializationError))
                        return
                    }
                    completion(.success(objectResponse))
                    return
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func dispatch(
        request: URLRequest,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0,
            execute: {                
                if let data = Mock.operate(request: request) {
                    completion(.success(data))
                } else {
                    completion(.failure(.invalidRequest))
                }
            }
        )
        /*
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                if let error = error as? URLError, error.code == .notConnectedToInternet {
                    completion(.failure(.connectivity))
                    return
                }
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if httpResponse.statusCode == 404 {
                completion(.failure(.urlNotFound))
                return
            }
            
            if !(200...299 ~= httpResponse.statusCode) {
                completion(.failure(.unknown))
                return
            }
            
            if let data = data {
                #if DEBUG
                print("#### RESPONSE: \(String(data: data, encoding: .utf8) ?? "not able to print data")")
                #endif
                completion(.success(data))
                return
            }
        }
        task.resume()
        */
    }
    
}

// MARK: Helpers
private extension NetworkDispatcher {
    
    private func buildTaskRequestFromRequest(_ request: RequestProtocol) -> Result<URLRequest, NetworkError> {
        guard var url = URL(string: request.endpoint) else {
            return .failure(.invalidURL)
        }
        if let pathParams = request.path {
            for pathParam in pathParams {
                url.appendPathComponent(pathParam)
            }
        }
        var taskRequest = URLRequest(url: url)
        #if DEBUG
        print("\n#### REQUEST: \(request.method.rawValue) - \(url.absoluteString)")
        #endif
        taskRequest.httpMethod = request.method.rawValue
        if let body = request.body {
            guard let dataBody = try? JSONSerialization.data(withJSONObject: body) else {
                return .failure(.invalidRequestBody)
            }
            taskRequest.httpBody = dataBody
            #if DEBUG
            print("-- BODY: \n\(String(data: dataBody, encoding: .utf8) ?? "")")
            #endif
        }
        
        #if DEBUG
        print("")
        #endif
        
        return .success(taskRequest)
    }
    
}
