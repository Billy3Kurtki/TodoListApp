//
//  TodoListService.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 01.06.2025.
//

import Foundation

protocol ITodoListService {
    
    func getTodos(completion: @escaping (Result<TodosDTO, NetworkError>) -> Void)
}

final class TodoListService: ITodoListService {
    
    // Dependencies
    static let shared: ITodoListService = TodoListService()
    private let networkService: INetworkService
    
    // MARK: - Initialization
    
    private init() {
        self.networkService = NetworkService.shared
    }
    
    // MARK: - Internal Methods
    
    func getTodos(completion: @escaping (Result<TodosDTO, NetworkError>) -> Void) {
        networkService.fetch(urlString: TodoTarget.getTodos.url, TodosDTO.self, completion: completion)
    }
}
