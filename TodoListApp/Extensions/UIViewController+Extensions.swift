//
//  UIViewController+Extensions.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit

// MARK: - Extension for IBaseView

protocol IBaseView: AnyObject {
    
    var viewController: UIViewController { get }
}

extension IBaseView where Self: UIViewController {
    
    var viewController: UIViewController {
        self
    }
}

// MARK: - Extension for UIViewController

extension UIViewController {
    
    var topMostViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }
        
        var topController = rootViewController
        while let presentedVC = topController.presentedViewController {
            topController = presentedVC
        }
        return topController
    }
}
