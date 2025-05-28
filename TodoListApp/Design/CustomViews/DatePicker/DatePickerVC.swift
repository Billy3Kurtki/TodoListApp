//
//  DatePickerVC.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 27.05.2025.
//

import UIKit

typealias DateAction = ((Date) -> Void)

final class DatePickerVC: UIViewController {
    
    // Properties
    private var currentDate: Date
    var onDateSelected: DateAction?
    
    // UI
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = currentDate
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    // MARK: - Initialization
    
    init(currentDate: Date? = nil) {
        self.currentDate = currentDate ?? Date()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDateSelected?(datePicker.date)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(CGFloat.contentMarginM)
        }
    }
}
