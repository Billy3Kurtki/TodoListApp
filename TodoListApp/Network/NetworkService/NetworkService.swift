//
//  NetworkService.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import Foundation

protocol INetworkService {
    
    func fetch<T: Decodable>(urlString: String,
                             _ type: T.Type,
                             completion: @escaping (Result<T, NetworkError>) -> Void)
    func post<T: Encodable>(urlString: String,
                            body: T,
                            method: HTTPMethod,
                            completion: @escaping (Result<Data?, NetworkError>) -> Void)
}

final class NetworkService: INetworkService {
    
    // Properties
    static let shared: INetworkService = NetworkService()
    private lazy var session = URLSession.shared
    
    private static let httpStatusCodeSuccess = 200..<300
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Internal Methods
    
    func fetch<T: Decodable>(urlString: String,
                             _ type: T.Type = T.self,
                             completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionOnMain(.failure(.invalidUrl))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completionOnMain(.failure(.requestError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionOnMain(.failure(.unexpectedResponse))
                return
            }
            
            guard Self.httpStatusCodeSuccess.contains(httpResponse.statusCode) else {
                completionOnMain(.failure(.failedResponse(httpResponse)))
                return
            }
            
            guard let data else {
                completionOnMain(.failure(.dataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseData = try decoder.decode(T.self, from: data)
                completionOnMain(.success(responseData))
            } catch {
                completionOnMain(.failure(.parseError))
            }
        }
        
        task.resume()
        
        func completionOnMain(_ result: Result<T, NetworkError>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func post<T: Encodable>(urlString: String,
                            body: T,
                            method: HTTPMethod,
                            completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionOnMain(.failure(.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestData = try JSONEncoder().encode(body)
            
            let task = session.uploadTask(with: urlRequest, from: requestData) { data, response, error in
                if let _ = error {
                    completionOnMain(.failure(.requestError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionOnMain(.failure(.unexpectedResponse))
                    return
                }
                
                guard Self.httpStatusCodeSuccess.contains(httpResponse.statusCode) else {
                    completionOnMain(.failure(.failedResponse(httpResponse)))
                    return
                }
                
                completionOnMain(.success(data))
            }
            
            task.resume()
        } catch {
            completionOnMain(.failure(.parseError))
        }
        
        func completionOnMain(_ result: Result<Data?, NetworkError>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

