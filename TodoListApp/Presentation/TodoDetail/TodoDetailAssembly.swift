//
//  TodoDetailAssembly.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 25.05.2025.
//

import UIKit

final class TodoDetailAssembly {
    
    // MARK: - Internal Methods
    
    func createModule(_ todo: TodoModel?,
                      completion: @escaping TodoAction) -> UIViewController {
        let router = makeRouter()
        let presenter = makePresenter(router, todo, completion)
        let view = makeView(presenter)
        
        presenter.view = view
        router.viewController = view.viewController
        
        return view.viewController
    }
    
    // MARK: - Private Methods
    
    private func makePresenter(_ router: ITodoDetailRouter,
                               _ todo: TodoModel?,
                               _ completion: @escaping TodoAction) -> ITodoDetailPresenter {
        let presenter = TodoDetailPresenter(router,
                                            todo,
                                            completion: completion)
        return presenter
    }
    
    private func makeRouter() -> TodoDetailRouter {
        let router = TodoDetailRouter()
        return router
    }
    
    private func makeView(_ presenter: ITodoDetailPresenter) -> ITodoDetailView {
        let view = TodoDetailVC(presenter)
        presenter.view = view
        return view
    }
}
