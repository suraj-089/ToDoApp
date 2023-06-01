//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Suraj Singh on 30/05/23.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    //MARK: - IBOutlets and Variables
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var addTime: UITextField!
    @IBOutlet weak var timeMode: UITextField!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var actionStack: UIStackView!
    var taskSchedule = ""
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setColors(textField: taskName, addTime, timeMode, color: ColorConstants.borderColor)
        UIApplication.shared.statusBarView?.backgroundColor = ColorConstants.white
        setPickerView()
    }
    
    //MARK: - Helper Methods
    private func setColors(textField: UITextField... , color: UIColor){
        for field in textField{
            field.layer.borderColor = color.cgColor
            field.layer.cornerRadius = 4.0
            field.layer.borderWidth = 1.0
        }
    }
    
    private func setPickerView(){
        time.datePickerMode = .time
        addTime.delegate = self
        taskName.delegate = self
        addTime.inputView = time
        let toolbar = createToolbar()
        addTime.inputAccessoryView = toolbar
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    //MARK: - IBAction
    @IBAction func cancellTapped(_ sender: Any) {
        let alertController = UIAlertController(title: StringConstants.alert, message: StringConstants.cancel, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: StringConstants.yes, style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if (taskName.text == "") || (addTime.text == ""){
            let alertController = UIAlertController(title: StringConstants.alert, message: StringConstants.empty, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: StringConstants.ok, style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
        let vm = AddNewTaskViewModel(name: taskName.text ?? "No Task", dueDate: time.date, time: taskSchedule)
            DispatchQueue.main.async {
                vm.saveTask { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }

    @objc func doneButtonTapped() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let selectedTime = formatter.string(from: time.date)
        taskSchedule = selectedTime
        let timeSeperator = selectedTime.components(separatedBy: " ")
        addTime.text = timeSeperator[0]
        timeMode.text = timeSeperator[1]
        addTime.resignFirstResponder()
    }
}

//MARK: - Adopting Textfield Delegate Protocols
extension AddTaskViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addTime{
            self.time.isHidden = false
            self.actionStack.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addTime{
            time.isHidden = true
            self.actionStack.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == taskName{
            let maxLength = 80
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
        return true
    }
    
}
