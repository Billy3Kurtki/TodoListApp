//
//  StorageError.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 01.06.2025.
//

import Foundation

enum StorageError: IAppError {
    case notFound
    case fetchError
    
    var title: String {
        switch self {
        case .notFound:   return "Не найдено"
        case .fetchError:  return "Ошибка получения данных"
        }
    }
    
    var message: String {
        switch self {
        case .notFound:     return "Элемент не найден в хранилище"
        case .fetchError:   return "Не удалось получить данные из хранилища"
        }
    }
}
