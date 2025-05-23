//
//  NetworkError.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import Foundation

protocol IAppError: Error {
    
    var title: String { get }
    var message: String { get }
}

enum NetworkError: IAppError {
    case invalidUrl
    case networkError
    case dataError
    case parseError
    case unexpectedResponse
    case failedResponse(HTTPURLResponse)
    case requestError
    case serverError
    
    var title: String {
        switch self {
        case .invalidUrl:         return "Неверный URL"
        case .networkError:       return "Ошибка сети"
        case .dataError:          return "Ошибка данных"
        case .parseError:         return "Ошибка обработки"
        case .unexpectedResponse: return "Неожиданный ответ"
        case .failedResponse:     return "Ошибка запроса"
        case .requestError:       return "Ошибка запроса"
        case .serverError:        return "Ошибка сервера"
        }
    }
    
    var message: String {
        switch self {
        case .invalidUrl:                   return "Указан неверный или некорректный URL адрес"
        case .networkError:                 return "Проблемы с интернет-соединением. Проверьте подключение к сети"
        case .dataError:                    return "Не удалось получить корректные данные"
        case .parseError:                   return "Ошибка при обработке полученных данных"
        case .unexpectedResponse:           return "Сервер вернул неожиданный формат ответа"
        case .failedResponse(let response): return "Запрос завершился с ошибкой. Код статуса: \(response.statusCode)"
        case .requestError:                 return "Ошибка при выполнении запроса к серверу"
        case .serverError:                  return "Внутренняя ошибка сервера. Попробуйте позже"
        }
    }
}

