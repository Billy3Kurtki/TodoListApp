//
//  TodoView.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 28.05.2025.
//

import UIKit
import UIView_Shimmer

final class TodoView: UIView {
    
    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline1.withSize(20)
        label.textColor = AppColors.Text.text1
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.text1.withSize(16)
        label.textColor = AppColors.Text.text1
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var targetDateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.text1.withSize(16)
        label.textColor = AppColors.Text.text2
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle for Cell Using
    
    func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        targetDateLabel.text = nil
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.contentMarginS)
            $0.horizontalEdges.equalToSuperview()
        }
        
        addSubview(targetDateLabel)
        targetDateLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.contentMarginS)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func updateStates(by isCompleted: Bool) {
        titleLabel.textColor = isCompleted ? AppColors.Text.text2 : AppColors.Text.text1
        
        let text = titleLabel.text ?? ""
        let attributedString = NSAttributedString(string: text,
                                                  attributes: isCompleted ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : nil)
        titleLabel.attributedText = attributedString
        descriptionLabel.textColor = isCompleted ? AppColors.Text.text2 : AppColors.Text.text1
        targetDateLabel.textColor = AppColors.Text.text2
    }
}

// MARK: - Configurable

extension TodoView: Configurable {
    
    func config(with model: TodoModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.todo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: model.targetDate)
        targetDateLabel.text = formattedDate
        
        updateStates(by: model.completed)
    }
    
    func configForShimmer() {
        titleLabel.text = "ShimmerTextTextMedium"
        descriptionLabel.text = "ShimmerTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextVeryLong"
        targetDateLabel.text = "ShimmerShort"
    }
}

// MARK: - ShimmeringViewProtocol

extension TodoView: ShimmeringViewProtocol {
    
    var shimmeringAnimatedItems: [UIView] {
        [titleLabel, descriptionLabel, targetDateLabel]
    }
}
