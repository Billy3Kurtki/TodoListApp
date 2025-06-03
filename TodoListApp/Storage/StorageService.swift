//
//  StorageService.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 01.06.2025.
//

import UIKit
import CoreData

// TODO: Переписать на дженерики, добавить TodoListStorage
protocol IStorageService {
    
    func fetchTodos() -> [TodoDBO]
    func fetchTodo(by id: Int) -> TodoDBO?
    func createTodo(with model: TodoModel)
    func updateTodo(with model: TodoModel)
    func deleteTodo(by id: Int)
    func todoCount() -> Int
}

final class StorageService {
    
    // Properties
    static let shared: IStorageService = StorageService()
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Initialization
    
    private init() {}
}

// MARK: - IStorageService

extension StorageService: IStorageService {
    
    func fetchTodos() -> [TodoDBO] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoDBO")
        
        do {
            return try context.fetch(fetchRequest) as? [TodoDBO] ?? []
        } catch {
            print(StorageError.fetchError.message)
            return []
        }
    }
    
    func fetchTodo(by id: Int) -> TodoDBO? {
        let items = fetchTodos()
        
        return items.first(where: { $0.id == id }) ?? {
            print(StorageError.notFound.message)
            return nil
        }()
    }
    
    func createTodo(with model: TodoModel) {
        let todoDBO = TodoDBO(context: context, todoModel: model)
        appDelegate.saveContext()
    }
    
    func updateTodo(with model: TodoModel) {
        guard let todoDBO = fetchTodo(by: model.id) else { return }
        todoDBO.title = model.title
        todoDBO.todo = model.todo
        todoDBO.completed = model.completed
        todoDBO.targetDate = model.targetDate
        
        appDelegate.saveContext()
    }
    
    func deleteTodo(by id: Int) {
        guard let todoDBO = fetchTodo(by: id) else { return }
        context.delete(todoDBO)
        
        appDelegate.saveContext()
    }
    
    func todoCount() -> Int {
        let todos = fetchTodos()
        return todos.count
    }
}
