//
//  ButtonFooterView.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 25.05.2025.
//

import UIKit

final class ButtonFooterView: UIView {
    
    // Properties
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    // UI
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        button.tintColor = .systemYellow
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        button.tintColor = .systemYellow
        return button
    }()
    
    private lazy var infoTextLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.text1.withSize(14)
        label.textColor = AppColors.Text.text1
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftButton, infoTextLabel, rightButton])
        stack.axis = .horizontal
        stack.spacing = .spacingM
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
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
        backgroundColor = AppColors.Background.bg3
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(CGFloat.contentMarginM)
            $0.horizontalEdges.equalToSuperview().inset(CGFloat.contentMarginM)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(CGFloat.contentMarginM)
        }
        
        containerView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.size.equalTo(CGFloat.contentSizeXL)
        }
        
        rightButton.snp.makeConstraints {
            $0.size.equalTo(CGFloat.contentSizeXL)
        }
    }
    
    // MARK: - User Interaction
    
    @objc
    private func leftAction() throws {
        leftButtonAction?()
    }
    
    @objc
    private func rightAction() throws {
        rightButtonAction?()
    }
}

// MARK: - Configurable

extension ButtonFooterView: Configurable {
    
    func config(with model: Model) {
        infoTextLabel.text = model.infoText
        
        if let leftIcon = model.leftButtonIcon,
           let leftAction = model.leftButtonAction {
            leftButton.setImage(leftIcon, for: .normal)
            leftButtonAction = leftAction
        }
        
        if let rightIcon = model.rightButtonIcon,
           let rightAction = model.rightButtonAction {
            rightButton.setImage(rightIcon, for: .normal)
            rightButtonAction = rightAction
        }
    }
    
    func update(with text: String) {
        infoTextLabel.text = text
    }
}

// MARK: - Model

extension ButtonFooterView {
    
    struct Model {
        let infoText: String
        let leftButtonIcon: UIImage?
        let leftButtonAction: (() -> Void)?
        let rightButtonIcon: UIImage?
        let rightButtonAction: (() -> Void)?
        
        init(infoText: String,
             leftButtonIcon: UIImage? = nil,
             leftButtonAction: (() -> Void)? = nil,
             rightButtonIcon: UIImage? = nil,
             rightButtonAction: (() -> Void)? = nil) {
            self.infoText = infoText
            self.leftButtonIcon = leftButtonIcon
            self.leftButtonAction = leftButtonAction
            self.rightButtonIcon = rightButtonIcon
            self.rightButtonAction = rightButtonAction
        }
    }
}
