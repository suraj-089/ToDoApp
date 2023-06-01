//
//  ToDoListTVC.swift
//  ToDoApp
//
//  Created by Suraj Singh on 30/05/23.
//

import UIKit

typealias sendButtonTapped = () -> ()

class ToDoListTVC: UITableViewCell {
    
    //MARK: - IBOutlets and Variables
    @IBOutlet private weak var taskNameLabel: UILabel!
    @IBOutlet private weak var taskDueDate: UILabel!
    @IBOutlet private weak var taskCompletedDate: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    var completedTapped: sendButtonTapped?
    var deletedTapped: sendButtonTapped?
    
    var todo: ToDo? {
        didSet {
            if let todo = todo {
                taskDueDate.text = todo.time
                if todo.completedTask == false {
                    taskNameLabel.text = todo.name
                    checkBox.image = UIImage(named: "Checkbox")
                    guard let dueOn = todo.dueOn else {return}
                    if dueOn < Date(){
                        taskCompletedDate.text = "Pending"
                        taskNameLabel.textColor = .red
                        taskCompletedDate.isHidden = false
                    }
                    else{
                        taskNameLabel.text = todo.name
                        taskNameLabel.textColor = ColorConstants.black
                        taskCompletedDate.isHidden = true
                    }
                }else {
                    taskNameLabel.attributedText = todo.name?.strikeThrough()
                    checkBox.image = UIImage(named: "checked")
                    taskCompletedDate.isHidden = true
                    taskNameLabel.textColor = ColorConstants.black
                }
            }
        }
    }
    
    //MARK: - Helpers
    override func prepareForReuse() {
        taskNameLabel.attributedText = taskNameLabel.text?.removeAttributedText()
        taskNameLabel.text = ""
        taskDueDate.attributedText = taskDueDate.text?.removeAttributedText()
        taskDueDate.text = ""
        taskCompletedDate.text = ""
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func deleteTapped(_ sender: Any) {
        guard let deletedTapped = deletedTapped else {return}
        deletedTapped()
    }
    
    @IBAction func checkTapped(_ sender: Any) {
        guard let completedTapped = completedTapped else {return}
        completedTapped()
    }
}
