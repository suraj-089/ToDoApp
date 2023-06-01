//
//  AddNewTaskViewModel.swift
//  ToDoApp
//
//  Created by Suraj Singh on 30/05/23.
//

import Foundation

class AddNewTaskViewModel {
    var name: String
    var dueDate: Date
    var time: String
    
    init(name: String, dueDate: Date, time: String) {
        self.name = name
        self.dueDate = dueDate
        self.time = time
    }
    
    func saveTask(completion: @escaping (Bool) -> Void) {
        CoreDataManager.shared.saveToDo(name: self.name, dueOn: self.dueDate, time: self.time, completion: completion)
    }
}
