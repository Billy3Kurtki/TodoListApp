//
//  TodoListAssembly.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 24.05.2025.
//

import UIKit

final class TodoListAssembly {
    
    // MARK: - Internal Methods
    
    func createModule() -> UIViewController {
        let interactor = makeInteractor()
        let router = makeRouter()
        let presenter = makePresenter(interactor, router)
        let view = makeView(presenter)
        
        presenter.view = view
        
        router.viewController = view.viewController
        
        return view.viewController
    }
    
    // MARK: - Private Methods
    
    private func makeInteractor() -> TodoListInteractor {
        let interactor = TodoListInteractor()
        return interactor
    }
    
    private func makePresenter(_ interactor: ITodoListInteractor, _ router: ITodoListRouter) -> ITodoListPresenter {
        let presenter = TodoListPresenter(interactor, router)
        return presenter
    }
    
    private func makeRouter() -> TodoListRouter {
        let router = TodoListRouter()
        return router
    }
    
    private func makeView(_ presenter: ITodoListPresenter) -> ITodoListView {
        let view = TodoListVC(presenter)
        presenter.view = view
        return view
    }
}
