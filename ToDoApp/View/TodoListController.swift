//
//  TodoListController.swift
//  ToDoApp
//
//  Created by Suraj Singh on 30/05/23.
//

import UIKit

class TodoListController: UIViewController {
    
    //MARK: - IBOutlets and Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    let vm = TodoListViewModel()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialis()
    }
    
    private func setInitialis(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.toDoListTVC, bundle: nil), forCellReuseIdentifier: CellConstants.toDoListTVC)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.layer.borderColor = ColorConstants.lightGreyColor.cgColor
        tableView.layer.cornerRadius = 4.0
        tableView.layer.borderWidth = 1.0
        UIApplication.shared.statusBarView?.backgroundColor = ColorConstants.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.height?.constant = 50*(CGFloat(vm.count))
    }
    
    //MARK: - Actions
    @IBAction func addTapped(_ sender: Any) {
        navigateToAddTask()
    }
    
    private func navigateToAddTask(){
        let storyBoard: UIStoryboard = UIStoryboard(name: ViewControllerConstants.main, bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: ViewControllerConstants.addTaskVC) as! AddTaskViewController
        navigationController?.pushViewController(home, animated: true);
    }
}

extension TodoListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.toDoListTVC) as! ToDoListTVC
        cell.todo = vm.todoAtIndex(indexPath.row)
        let todo = vm.todoAtIndex(indexPath.row)
        
        if todo.completedTask == false {
            cell.completedTapped = {
                self.vm.completeTaskAtIndex(indexPath.row) { (_) in
                    tableView.reloadData()
                }
            }
        }
        
        cell.deletedTapped = {
            let alertController = UIAlertController(title: StringConstants.alert, message: StringConstants.deleteWarning, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: StringConstants.yes, style: .default, handler: { (_) in
                self.vm.deleteTask(indexPath.row) { (_) in
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                self.tableView.reloadData()
                self.height?.constant = 50*(CGFloat(self.vm.count))
               
            }))
            alertController.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
        return cell
    }
    
    
}
