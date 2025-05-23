//
//  TodoDTO.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import Foundation

struct TodoDTO: Decodable {
    
    // Properties
    let id: Int
    let title: String
    let todo: String
    let completed: Bool
    let targetDateTimestamp: Int
    
    var targetDate: Date {
        Date(timeIntervalSince1970: TimeInterval(targetDateTimestamp))
    }
    
    // MARK: - Initialization
    
    init(id: Int, todo: String, completed: Bool) {
        self.id = id
        self.title = MockTodoTitle.allCases.randomElement()?.title ?? ""
        self.todo = todo
        self.completed = completed
        
        let currentDate = Date()
        let randomInterval: TimeInterval = Double.random(in: -172800...172800) // 2 дня
        let randomTimestamp = currentDate.addingTimeInterval(randomInterval)
        self.targetDateTimestamp = Int(randomTimestamp.timeIntervalSince1970)
    }
}

// MARK: - Mocks

enum MockTodoTitle: CaseIterable {
    case clean
    case buy
    case sport
    case chill
    
    var title: String {
        switch self {
        case .clean: return "Уборка в квартире"
        case .buy:   return "Купить продуктов"
        case .sport: return "Заняться спортом"
        case .chill: return "Отдохнуть на диване"
        }
    }
}
