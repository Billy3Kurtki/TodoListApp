//
//  TodoListRouter.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 24.05.2025.
//

import UIKit

protocol ITodoListRouter: AnyObject {
    
    func openTodoDetailModule(with todo: TodoDTO) throws
}

final class TodoListRouter: ITodoListRouter {
    
    // Dependencies
    weak var viewController: UIViewController?
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Internal Methods
    
    func openTodoDetailModule(with todo: TodoDTO) throws {
//        guard let navigationController = viewController?.navigationController else { fatalError() }
//        let vc = TodoDetailAssembly()
//        navigationController.pushViewController(vc, animated: true)
    }
}
