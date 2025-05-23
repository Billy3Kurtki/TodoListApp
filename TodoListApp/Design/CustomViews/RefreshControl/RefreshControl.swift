//
//  RefreshControl.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit
import Foundation

final class RefreshControl: UIRefreshControl {
    
    // Properties
    private var action: Action?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        tintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    @objc
    private func useAction() throws {
        action?()
    }

    // MARK: - Methods
    
    func addAction(_ action: @escaping Action) {
        self.action = action
        addTarget(self, action: #selector(useAction), for: .valueChanged)
        beginRefreshing()
        endRefreshing()
    }
}
