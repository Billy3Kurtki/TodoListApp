//
//  TodoListPresenter.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 23.05.2025.
//

import UIKit

protocol ITodoListPresenter: AnyObject {
    
    var view: ITodoListView? { get set }
    var isLoading: Bool { get }
    var filteredTodos: [TodoModel] { get }
    func viewDidLoad()
    func pullToRefresh()
    func searchTextChanged(_ text: String)
    func todoDidTap(at indexPath: IndexPath)
    func newTodoButtonDidTap()
    func editButtonTapped(at indexPath: IndexPath)
    func shareButtonTapped(at indexPath: IndexPath)
    func deleteButtonTapped(at indexPath: IndexPath)
}

final class TodoListPresenter {
    
    // Dependencies
    weak var view: ITodoListView?
    private let interactor: ITodoListInteractor
    private let router: ITodoListRouter
    
    // Properties
    private var todos = [TodoModel]()
    private(set) var filteredTodos = [TodoModel]()
    private(set) var isLoading = false
    private var searchText = ""
    private let defaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    init(_ interactor: ITodoListInteractor,
         _ router: ITodoListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func fetchData() {
        isLoading = true
        view?.reloadData()
        
        if defaults.bool(forKey: "networkDataDidLoad") {
            interactor.getTodos(from: .storage) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let todos):
                    self.todos = todos
                    self.filteredTodos = !self.searchText.isEmpty ? self.todos.filter { $0.title.contains(self.searchText) } : self.todos
                    self.isLoading = false
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showAlert(with: error)
                }
            }
        } else {
            interactor.getTodos(from: .network) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let todos):
                    self.todos = todos
                    self.filteredTodos = !self.searchText.isEmpty ? self.todos.filter { $0.title.contains(self.searchText) } : self.todos
                    self.interactor.saveTodos(to: .storage, todos) // First Save to Database from Network
                    self.defaults.set(true, forKey: "networkDataDidLoad")
                    self.isLoading = false
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.showAlert(with: error)
                }
            }
        }
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        let todo = filteredTodos[indexPath.row]
        filteredTodos.remove(at: indexPath.row)
        todos.removeAll(where: { $0.id == todo.id })
        interactor.deleteTodo(by: todo.id)
        view?.deleteRow(at: indexPath)
    }
}

// MARK: - ITodoListPresenter

extension TodoListPresenter: ITodoListPresenter {
    
    func viewDidLoad() {
        fetchData()
    }
    
    func pullToRefresh() {
        fetchData()
    }
    
    // TODO: Добавить задержку в 1 секунду
    func searchTextChanged(_ text: String) {
        searchText = text.lowercased()
        filteredTodos = !searchText.isEmpty ? todos.filter { $0.title.lowercased().contains(searchText) } : todos
        view?.reloadData()
    }
    
    func todoDidTap(at indexPath: IndexPath) {
        let todo = filteredTodos[indexPath.row]
        try? router.openTodoDetailModule(with: todo) { [weak self] updatedTodo in
            self?.filteredTodos[indexPath.row] = updatedTodo
            if let index = self?.todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                self?.todos[index] = updatedTodo
            }
            self?.interactor.updateTodo(updatedTodo)
            self?.view?.reloadRow(at: indexPath)
        }
    }
    
    func newTodoButtonDidTap() {
        try? router.openTodoDetailModule(with: nil) { [weak self] newTodo in
            self?.filteredTodos.insert(newTodo, at: 0)
            self?.todos.insert(newTodo, at: 0)
            self?.interactor.createTodo(newTodo)
            self?.view?.insertRow(at: IndexPath(row: 0, section: 0))
        }
    }
    
    func editButtonTapped(at indexPath: IndexPath) {
        todoDidTap(at: indexPath)
    }
    
    func shareButtonTapped(at indexPath: IndexPath) {
        print("shareButtonTapped")
    }
    
    func deleteButtonTapped(at indexPath: IndexPath) {
        deleteTodo(at: indexPath)
    }
}

// MARK: - TodoModel

struct TodoModel {
    let id: Int
    var title: String
    var todo: String
    var completed: Bool
    var targetDate: Date
}

// MARK: - Additional Initialization from TodoDTO

extension TodoModel {
    
    init(from dto: TodoDTO) {
        self.id = dto.id
        self.title = dto.title
        self.todo = dto.todo
        self.completed = dto.completed
        self.targetDate = dto.targetDate
    }
    
    init(from dbo: TodoDBO) {
        self.id = Int(dbo.id)
        self.title = dbo.title
        self.todo = dbo.todo
        self.completed = dbo.completed
        self.targetDate = dbo.targetDate
    }
}
