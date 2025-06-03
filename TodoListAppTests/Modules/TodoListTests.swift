//
//  TodoListTests.swift
//  TodoListAppTests
//
//  Created by Кирилл Казаков on 02.06.2025.
//

import XCTest
@testable import TodoListApp

final class TodoListTests: XCTestCase {
    
    // Dependencies
    private var sut: ITodoListPresenter!
    private var mockView: MockView!
    private var mockRouter: MockRouter!
    private var mockInteractor: MockInteractor!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        mockView = MockView()
        mockRouter = MockRouter()
        mockInteractor = MockInteractor()
        sut = TodoListPresenter(mockInteractor, mockRouter)
        sut.view = mockView
    }
    
    override func tearDown() {
        mockView = nil
        sut = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    // MARK: - Internal Methods
    
    func testShowAlertWhenViewDidLoadAndGetTodos() {
        // Given
        mockInteractor.shouldReturnError = true
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.didShowAlert)
    }
    
    func testReloadDataWhenViewDidLoad() {
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.didReloadData)
    }
    
    func testReloadDataWhenPullToRefresh() {
        // When
        sut.pullToRefresh()
        
        // Then
        XCTAssertTrue(mockView.didReloadData)
    }
    
    func testOpenDetailModuleWhenViewDidLoadAndTodoDidTap() {
        // Given
        mockInteractor.todos = [
            TodoModel(id: 1,
                      title: "test",
                      todo: "test",
                      completed: false,
                      targetDate: Date())
        ]
        
        // When
        sut.viewDidLoad()
        sut.todoDidTap(at: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertTrue(mockRouter.todoDetailDidOpen)
    }
    
    // TODO: Add More Tests
}

// MARK: - MockView

private final class MockView: ITodoListView {
    
    // Properties
    var didShowAlert = false
    var didReloadData = false
    var reloadedRowIndexPath = IndexPath()
    var insertedRowIndexPath = IndexPath()
    var deletedRowIndexPath = IndexPath()
    
    var viewController = UIViewController()
    
    // MARK: - Internal Methods
    
    func showAlert(with error: any TodoListApp.IAppError) {
        didShowAlert = true
    }
    
    func reloadData() {
        didReloadData = true
    }
    
    func reloadRow(at indexPath: IndexPath) {
        reloadedRowIndexPath = indexPath
    }
    
    func insertRow(at indexPath: IndexPath) {
        insertedRowIndexPath = indexPath
    }
    
    func deleteRow(at indexPath: IndexPath) {
        deletedRowIndexPath = indexPath
    }
}

// MARK: - MockRouter

private final class MockRouter: ITodoListRouter {
    
    // Properties
    var todoDetailDidOpen = false
    var completion: TodoAction?
    
    // MARK: - Internal Methods
    
    func openTodoDetailModule(with todo: TodoListApp.TodoModel?,
                              completion: @escaping TodoListApp.TodoAction) throws {
        todoDetailDidOpen = true
        self.completion = completion
    }
}

// MARK: - MockInteractor

private final class MockInteractor: ITodoListInteractor {
    
    // Properties
    var shouldReturnError = false
    var todos = [TodoModel]()
    
    var didCreateTodo = false
    var didUpdateTodo = false
    var didDeleteTodo = false
    
    // MARK: - Internal Methods
    
    func getTodos(from: TodoListApp.DataSourceType,
                  completion: @escaping (Result<[TodoListApp.TodoModel],
                                         TodoListApp.NetworkError>) -> Void) {
        if !shouldReturnError,
           !todos.isEmpty {
            completion(.success(todos))
        } else {
            completion(.failure(NetworkError.networkError))
        }
    }
    
    func saveTodos(to dataSourceType: TodoListApp.DataSourceType,
                   _ todoModels: [TodoListApp.TodoModel]) { }
    
    func createTodo(_ todoModel: TodoListApp.TodoModel) {
        didCreateTodo = true
    }
    
    func updateTodo(_ todoModel: TodoListApp.TodoModel) {
        didUpdateTodo = true
    }
    
    func deleteTodo(by id: Int) {
        didDeleteTodo = true
    }
}
