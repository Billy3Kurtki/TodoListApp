//
//  MockAlertManager.swift
//  TodoListAppTests
//
//  Created by Кирилл Казаков on 02.06.2025.
//

import Foundation
@testable import TodoListApp

final class MockAlertManager: IAlertManager {
    
    // Properties
    var didShowAlert = false
    
    // MARK: - Internal Methods
    
    func show(_ error: any TodoListApp.IAppError) {
        didShowAlert = true
    }
}
