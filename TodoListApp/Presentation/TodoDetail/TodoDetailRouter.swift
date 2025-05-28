//
//  TodoDetailRouter.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 27.05.2025.
//

import UIKit

protocol ITodoDetailRouter: AnyObject {
    
    func openBottomSheet(with vc: UIViewController)
}

final class TodoDetailRouter: ITodoDetailRouter {
    
    // Dependencies
    weak var viewController: UIViewController?
    
    // MARK: - Initialization
    
    init() { }
    
    // MARK: - Internal Methods
    
    func openBottomSheet(with vc: UIViewController) {
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        viewController?.present(vc, animated: true)
    }
}
