//
//  Date+Extensions.swift
//  ToDoApp
//
//  Created by Suraj Singh on 31/05/23.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
