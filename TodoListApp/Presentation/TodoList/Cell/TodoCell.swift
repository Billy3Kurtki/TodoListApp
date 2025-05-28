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
    
    private lazy var VStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            targetDateLabel
        ])
        
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = .spacingS
        
        return stack
    }()
    
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
        titleLabel.text = nil
        descriptionLabel.text = nil
        targetDateLabel.text = nil
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
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(completeIcon.snp.right).offset(CGFloat.contentMarginS)
            $0.right.equalToSuperview().inset(CGFloat.contentMarginS)
        }
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.contentMarginS)
            $0.left.equalTo(completeIcon.snp.right).offset(CGFloat.contentMarginS)
            $0.right.equalToSuperview().inset(CGFloat.contentMarginS)
        }
        
        containerView.addSubview(targetDateLabel)
        targetDateLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.contentMarginS)
            $0.left.equalTo(completeIcon.snp.right).offset(CGFloat.contentMarginS)
            $0.right.equalToSuperview().inset(CGFloat.contentMarginS)
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

// MARK: - ConfigurableAndReusable

extension TodoCell: ConfigurableAndReusable {
    
    func config(with model: TodoModel) {
        completeIcon.image = UIImage(named: model.completed ? "completedMark" : "notCompletedMark")
        titleLabel.text = model.title
        descriptionLabel.text = model.todo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: model.targetDate)
        targetDateLabel.text = formattedDate
        
        updateStates(by: model.completed)
    }
    
    func configForShimmer() {
        completeIcon.image = UIImage(named: "notCompletedMark")
        titleLabel.text = "ShimmerTextTextMedium"
        descriptionLabel.text = "ShimmerTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextVeryLong"
        targetDateLabel.text = "ShimmerShort"
    }
}

// MARK: - ShimmeringViewProtocol

extension TodoCell: ShimmeringViewProtocol {
    
    var shimmeringAnimatedItems: [UIView] {
        [completeIcon, titleLabel, descriptionLabel, targetDateLabel]
    }
}
