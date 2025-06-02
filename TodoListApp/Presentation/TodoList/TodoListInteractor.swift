//
//  TodoListInteractor.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 24.05.2025.
//

import Foundation

protocol ITodoListInteractor: AnyObject {
    
    func getTodos(from: DataSourceType, completion: @escaping (Result<[TodoModel], NetworkError>) -> Void)
    func saveTodos(to dataSourceType: DataSourceType, _ todoModels: [TodoModel])
    func createTodo(_ todoModel: TodoModel)
    func updateTodo(_ todoModel: TodoModel)
    func deleteTodo(by id: Int)
}

final class TodoListInteractor {
    
    // Dependencies
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Private Methods
    
    // Network
    private func getTodosFromNetwork(completion: @escaping (Result<TodosDTO, NetworkError>) -> Void) {
        networkService.fetch(urlString: TodoTarget.getTodos.url, TodosDTO.self, completion: completion)
    }
    
    // Storage
    private func getTodosFromDatabase() -> [TodoDBO] {
        storageService.fetchTodos()
    }
    
    private func saveTodosToDatabase(_ todoModels: [TodoModel]) {
        todoModels.forEach { storageService.createTodo(with: $0) }
    }
}

// MARK: - ITodoListInteractor

extension TodoListInteractor: ITodoListInteractor {
    
    func getTodos(from dataSourceType: DataSourceType, completion: @escaping (Result<[TodoModel], NetworkError>) -> Void) {
        switch dataSourceType {
        case .network:
            getTodosFromNetwork { result in
                switch result {
                case .success(let todosDTO):
                    let todoDTOs = todosDTO.todos
                    let todoModels = todoDTOs.map { TodoModel(from: $0) }
                    completion(.success(todoModels))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .storage:
            let todoDBOs = getTodosFromDatabase()
            let todoModels = todoDBOs.map { TodoModel(from: $0) }
            completion(.success(todoModels))
        }
    }
    
    func saveTodos(to dataSourceType: DataSourceType, _ todoModels: [TodoModel]) {
        switch dataSourceType {
        case .network:
            // TODO
            print("")
        case .storage:
            saveTodosToDatabase(todoModels)
        }
    }
    
    func createTodo(_ todoModel: TodoModel) {
        // TODO: Добавить создание в Network
        storageService.createTodo(with: todoModel)
    }
    
    func updateTodo(_ todoModel: TodoModel) {
        // TODO: Добавить обновление в Network
        storageService.updateTodo(with: todoModel)
    }
    
    func deleteTodo(by id: Int) {
        // TODO: Добавить удаление в Network
        storageService.deleteTodo(by: id)
    }
}

// MARK: - DataSourceType

enum DataSourceType {
    case network
    case storage
}
