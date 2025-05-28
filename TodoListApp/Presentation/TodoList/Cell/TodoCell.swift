//
//  TodoCell.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit
import UIView_Shimmer

final class TodoCell: UITableViewCell {
    
    // UI
    private lazy var containerView = UIView()
    
    private lazy var completeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = .radiusS
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var todoView = TodoView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        completeIcon.image = nil
        todoView.prepareForReuse()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(CGFloat.contentMarginXS)
            $0.horizontalEdges.equalToSuperview().inset(CGFloat.contentMarginM)
        }
        
        containerView.addSubview(completeIcon)
        completeIcon.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(CGFloat.contentSizeXL)
        }
        
        containerView.addSubview(todoView)
        todoView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalTo(completeIcon.snp.right).offset(CGFloat.contentMarginS)
            $0.right.equalToSuperview().inset(CGFloat.contentMarginS)
        }
    }
}

// MARK: - ConfigurableAndReusable

extension TodoCell: ConfigurableAndReusable {
    
    func config(with model: TodoModel) {
        completeIcon.image = UIImage(named: model.completed ? "completedMark" : "notCompletedMark")
        todoView.config(with: model)
    }
    
    func configForShimmer() {
        completeIcon.image = UIImage(named: "notCompletedMark")
        todoView.configForShimmer()
    }
}

// MARK: - ShimmeringViewProtocol

extension TodoCell: ShimmeringViewProtocol {
    
    var shimmeringAnimatedItems: [UIView] {
        [completeIcon]
    }
}
