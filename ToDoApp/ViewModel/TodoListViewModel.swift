//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Suraj Singh on 30/05/23.
//

import Foundation

class TodoListViewModel {
    var todos = [ToDo]()
    
    var count: Int {
        return todos.count
    }
    
    init() {
        self.refreshData()
    }
    
    func todoAtIndex(_ index: Int) -> ToDo {
        return todos[index]
    }
    
    func refreshData() {
        self.todos = CoreDataManager.shared.getAllTodos().filter({$0.name != ""})
    }
    
    func completeTaskAtIndex(_ index: Int, completion: @escaping (Bool) -> Void) {
        self.refreshData()
        CoreDataManager.shared.completeTask(todo: todos[index], completion: completion)
    }
    
    func deleteTask(_ index: Int, completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.deleteTask(todo: todos[index]) { (_) in
            self.refreshData()
            completion(true)
        }
    }
}
