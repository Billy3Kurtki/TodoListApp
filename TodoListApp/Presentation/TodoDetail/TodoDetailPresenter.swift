//
//  TodoDetailPresenter.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 25.05.2025.
//

import UIKit

typealias TodoAction = (TodoModel) -> Void

protocol ITodoDetailPresenter: AnyObject {
    
    var view: ITodoDetailView? { get set }
    func viewDidLoad()
    func viewDidDisappear()
    func setText(_ text: String, for field: TodoFields)
    func dateFieldTapped()
    func isCompletedButtonTapped()
}

final class TodoDetailPresenter {
    
    // Dependencies
    weak var view: ITodoDetailView?
    private let router: ITodoDetailRouter
    
    // Properties
    private let completion: TodoAction
    private var fields = [TodoFields: Any]()
    
    // MARK: - Initialization
    
    init(_ router: ITodoDetailRouter,
         _ todo: TodoModel?,
         completion: @escaping TodoAction) {
        self.router = router
        self.completion = completion
        setupDictionaryFields(by: todo)
    }
    
    // MARK: - Private Methods
    
    private func setupDictionaryFields(by todo: TodoModel?) {
        guard let todo else { return }
        for type in TodoFields.allCases {
            switch type {
            case .id:         fields[type] = todo.id
            case .title:      fields[type] = todo.title
            case .todo:       fields[type] = todo.todo
            case .completed:  fields[type] = todo.completed
            case .targetDate: fields[type] = todo.targetDate
            }
        }
    }
    
    private func setupFields() {
        guard !fields.isEmpty else {
            view?.hideCompleteButton()
            return
        }
        
        for (type, value) in fields {
            switch value {
            case is String: view?.setValue(value as? String ?? "", for: type)
            case is Int:    view?.setValue(String(value as? Int ?? 0), for: type)
            case is Bool:   view?.updateIsCompletedState(value as? Bool ?? false)
            case is Date:   view?.setValue(formattedDateString(by: value as? Date) ?? "Дата", for: type)
            default: continue
            }
        }
    }
    
    private func getTodoModel() -> TodoModel? {
        if let todo = fields[.todo] as? String,
           let title = fields[.title] as? String,
           let targetDate = fields[.targetDate] as? Date {
            return TodoModel(id: fields[.id] as? Int ?? Int.random(in: 0...1000),
                             title: title,
                             todo: todo,
                             completed: fields[.completed] as? Bool ?? false,
                             targetDate: targetDate)
        }
        
        return nil
    }
    
    private func showDatePicker() {
        let datePickerVC = DatePickerVC(currentDate: fields[.targetDate] as? Date)
        
        datePickerVC.onDateSelected = { [weak self] selectedDate in
            print("Выбрана дата: \(selectedDate)")
            self?.fields[.targetDate] = selectedDate
            self?.view?.setValue(self?.formattedDateString(by: selectedDate) ?? "", for: .targetDate)
        }
        
        router.openBottomSheet(with: datePickerVC)
    }
    
    private func formattedDateString(by date: Date?) -> String? {
        guard let date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

// MARK: - ITodoDetailPresenter

extension TodoDetailPresenter: ITodoDetailPresenter {
    
    func viewDidLoad() {
        setupFields()
    }
    
    func viewDidDisappear() {
        guard let todoModel = getTodoModel() else { return }
        completion(todoModel)
    }
    
    func setText(_ text: String, for field: TodoFields) {
        fields[field] = text
    }
    
    func dateFieldTapped() {
        showDatePicker()
    }
    
    func isCompletedButtonTapped() {
        if var state = fields[.completed] as? Bool {
            state.toggle()
            fields[.completed] = state
            view?.updateIsCompletedState(state)
        } else {
            fields[.completed] = true
            view?.updateIsCompletedState(true)
        }
    }
}

// MARK: - Fields

enum TodoFields: CaseIterable {
    case id
    case todo
    case completed
    case title
    case targetDate
    
    var isRequired: Bool { return true }
}
