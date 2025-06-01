//
//  TodoSnippet.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 28.05.2025.
//

import UIKit

final class TodoSnippetView: UIView {
    
    // UI
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.Background.bg3
        view.layer.cornerRadius = .radiusS
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var todoView = TodoView()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(todoView)
        todoView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(CGFloat.contentMarginS)
            $0.horizontalEdges.equalToSuperview().inset(CGFloat.contentMarginM)
        }
    }
}

// MARK: - Configurable

extension TodoSnippetView: Configurable {
    
    func config(with model: TodoModel) {
        todoView.config(with: model)
    }
}
