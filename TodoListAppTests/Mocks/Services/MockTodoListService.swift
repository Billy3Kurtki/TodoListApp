//
//  MockNetworkService.swift
//  TodoListAppTests
//
//  Created by Кирилл Казаков on 01.06.2025.
//

import Foundation
@testable import TodoListApp

final class MockTodoListService: ITodoListService {
    
    // Properties
    var shouldReturnError = false
    var todosDTO: TodosDTO?
    
    // MARK: - Internal Methods
    
    func getTodos(completion: @escaping (Result<TodosDTO, NetworkError>) -> Void) {
        if !shouldReturnError,
           let todosDTO {
            completion(.success(todosDTO))
        } else {
            completion(.failure(.networkError))
        }
    }
}

