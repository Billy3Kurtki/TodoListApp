//
//  TodoDetailVC.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 25.05.2025.
//

import UIKit

private enum Const {
    static let navbarHeight: CGFloat = 158
}

protocol ITodoDetailView: IBaseView {
    
    func setValue(_ value: String, for type: TodoFields)
    func updateIsCompletedState(_ state: Bool)
}

final class TodoDetailVC: UIViewController {
    
    // Dependencies
    private let presenter: ITodoDetailPresenter
    
    // UI
    private lazy var containerView = UIView()
    
    private lazy var titleField: CustomTextField = {
        let field = CustomTextField()
        field.textColor = AppColors.Text.text1
        field.font = AppFonts.headline1.withSize(35)
        field.placeholder = "Название"
        field.setupDelegate()
        field.valueChanged = { [weak self] newText in
            self?.presenter.setText(newText, for: .title)
        }
        
        return field
    }()
    
    private lazy var dateField: UIButton = {
        let button = UIButton()
        button.setTitle("Дата", for: .normal)
        button.titleLabel?.font = AppFonts.text1.withSize(20)
        button.titleLabel?.textColor = AppColors.Text.text2
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(dateFieldTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var todoField: CustomTextView = {
        let field = CustomTextView()
        field.textColor = AppColors.Text.text1
        field.font = AppFonts.text1.withSize(20)
        field.setupDelegate()
        field.valueChanged = { [weak self] newText in
            self?.presenter.setText(newText, for: .todo)
        }
        
        return field
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "notCompletedMark"), for: .normal)
        button.addTarget(self, action: #selector(isCompletedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    init(_ presenter: ITodoDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Const.navbarHeight)
            $0.horizontalEdges.bottom.equalToSuperview().inset(CGFloat.contentMarginM)
        }
        
        containerView.addSubview(titleField)
        titleField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        containerView.addSubview(dateField)
        dateField.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(CGFloat.contentMarginS)
            $0.left.equalToSuperview()
        }
        
        containerView.addSubview(todoField)
        todoField.snp.makeConstraints {
            $0.top.equalTo(dateField.snp.bottom).offset(CGFloat.contentMarginS)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
    }
    
    // MARK: - User Interaction
    
    @objc private func dateFieldTapped() {
        presenter.dateFieldTapped()
    }
    
    @objc private func isCompletedButtonTapped() {
        presenter.isCompletedButtonTapped()
    }
}

// MARK: - ITodoDetailView

extension TodoDetailVC: ITodoDetailView {
    
    func setValue(_ value: String, for type: TodoFields) {
        switch type {
        case .todo:       todoField.text = value
        case .title:      titleField.text = value
        case .targetDate: dateField.setTitle(value, for: .normal)
        default: return
        }
    }
    
    func updateIsCompletedState(_ state: Bool) {
        completeButton.setImage(UIImage(named: state ? "completedMark" : "notCompletedMark"), for: .normal)
    }
}
