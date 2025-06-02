//
//  TodoDBO+CoreDataProperties.swift
//  TodoListApp
//
//  Created by Кирилл Казаков on 01.06.2025.
//
//

import Foundation
import CoreData

@objc(TodoDBO)
public class TodoDBO: NSManagedObject {}

extension TodoDBO {

    @NSManaged public var id: Int16
    @NSManaged public var title: String
    @NSManaged public var todo: String
    @NSManaged public var completed: Bool
    @NSManaged public var targetDate: Date
}

extension TodoDBO : Identifiable {}

// MARK: - Additional Initializer

extension TodoDBO {
    
    convenience init(context: NSManagedObjectContext, todoModel: TodoModel) {
        let entity = NSEntityDescription.entity(forEntityName: "TodoDBO", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.id = Int16(todoModel.id)
        self.title = todoModel.title
        self.todo = todoModel.todo
        self.completed = todoModel.completed
        self.targetDate = todoModel.targetDate
    }
}
