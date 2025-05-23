//
//  Protocols+Extensions.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import Foundation

typealias ConfigurableAndReusable = Configurable & Reusable

// MARK: - Configurable

protocol Configurable {
    
    associatedtype Model
    func config(with model: Model)
}

// MARK: - Reusable

protocol Reusable {
    
    static var reuseID: String { get }
}

extension Reusable {
    
    static var reuseID: String {
        return String(describing: self)
    }
}
