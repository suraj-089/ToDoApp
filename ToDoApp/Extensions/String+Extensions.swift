//
//  String+Extensions.swift
//  ToDoApp
//
//  Created by Suraj Singh on 31/05/23.
//

import Foundation
extension String {
    func strikeThrough() -> NSAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attrString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attrString.length))
        return attrString
    }
    
    func removeAttributedText() -> NSAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attrString.setAttributes([:], range: NSRange(location: 0, length: attrString.length))
        return attrString
    }
}

