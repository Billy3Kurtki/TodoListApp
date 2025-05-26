//
//  TodoListInteractor.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 24.05.2025.
//

import Foundation

protocol ITodoListInteractor: AnyObject {
    
    func getTodos(from: DataSourceType, completion: @escaping (Result<[TodoDTO], NetworkError>) -> Void)
}

final class TodoListInteractor {
    
    // Dependencies
    private let networkService = NetworkService.shared
//    private let databaseService = DatabaseService.shared
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Private Methods
    
    // Network
    private func getTodosFromNetwork(completion: @escaping (Result<TodosDTO, NetworkError>) -> Void) {
        networkService.fetch(urlString: TodoTarget.getTodos.url, TodosDTO.self, completion: completion)
    }
    
    // Database
    private func getTodosFromDatabase(completion: @escaping (Result<[TodoDTO], NetworkError>) -> Void) {
//        databaseService.fetch(urlString: TodoTarget.getTodos.url, [TodoDTO].self, completion: completion)
    }
}

// MARK: - ITodoListInteractor

extension TodoListInteractor: ITodoListInteractor {
    
    func getTodos(from dataSourceType: DataSourceType, completion: @escaping (Result<[TodoDTO], NetworkError>) -> Void) {
        switch dataSourceType {
        case .network:
            getTodosFromNetwork { result in
                switch result {
                case .success(let todosDTO):
                    completion(.success(todosDTO.todos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .database:
            getTodosFromDatabase(completion: completion)
        }
    }
}

// MARK: - DataSourceType

enum DataSourceType {
    case network
    case database
}
