//
//  AlertManager.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit

protocol IAlertManager: AnyObject {
    
    func show(_ error: IAppError)
}

final class AlertManager: IAlertManager {
    
    // MARK: - Internal Methods
    
    func show(_ error: IAppError) {
        let alertViewController = UIAlertController(title: error.title,
                                                    message: error.message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Понятно",
                                     style: .default,
                                     handler: { sone in
            print("okAction")
            alertViewController.dismiss(animated: true)
        })
        
        alertViewController.addAction(okAction)
        
        let presentingVC = UIViewController().topMostViewController
        presentingVC?.present(alertViewController, animated: true)
    }
}
