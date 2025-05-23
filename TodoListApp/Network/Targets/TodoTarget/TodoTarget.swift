//
//  TodoTarget.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

enum TodoTargetTarget {
    case getTodos

    var url: String {
        switch self {
        case .getTodos: return "https://dummyjson.com/todos"
        }
    }
    
    var method: HTTPMethod? { return nil }
}
