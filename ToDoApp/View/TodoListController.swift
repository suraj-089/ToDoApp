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
    @IBOutlet weak var addTask: UILabel!
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
        if CoreDataManager.shared.getAllTodos().count == 0{
            addTask.isHidden = false
        }
        else{
            addTask.isHidden = true
        }
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
    
    
    @IBAction func sortTapped(_ sender: Any) {
        onSortTapped()
    }

    @IBAction func filterTapped(_ sender: Any) {
        onFilterTapped()
    }
    
    //MARK: - Helpers
    private func navigateToAddTask(){
        let storyBoard: UIStoryboard = UIStoryboard(name: ViewControllerConstants.main, bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: ViewControllerConstants.addTaskVC) as! AddTaskViewController
        navigationController?.pushViewController(home, animated: true);
    }
    
    private func onSortTapped(){
        let alert = UIAlertController(title: StringConstants.sort, message: StringConstants.sortOption, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: StringConstants.time, style: .default , handler:{ (UIAlertAction)in
            self.vm.sortByDate()
            self.tableView.reloadData()
            self.height?.constant = 50*(CGFloat(self.vm.count))
            self.showNoTask(totalTasks: self.vm.count)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.name, style: .default , handler:{ (UIAlertAction)in
            self.vm.sortByName()
            self.tableView.reloadData()
            self.height?.constant = 50*(CGFloat(self.vm.count))
            self.showNoTask(totalTasks: self.vm.completedCount)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.cancelAction, style: .default , handler:{ (UIAlertAction)in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func onFilterTapped(){
        let alert = UIAlertController(title: StringConstants.filter, message: StringConstants.filterOption, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: StringConstants.all, style: .default , handler:{ (UIAlertAction)in
            self.vm.refreshData()
            self.tableView.reloadData()
            self.height?.constant = 50*(CGFloat(self.vm.count))
            self.showNoTask(totalTasks: self.vm.count)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.completed, style: .default , handler:{ (UIAlertAction)in
            self.vm.completedTask()
            self.tableView.reloadData()
            self.height?.constant = 50*(CGFloat(self.vm.count))
            self.showNoTask(totalTasks: self.vm.completedCount)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.pending, style: .default , handler:{ (UIAlertAction)in
            self.vm.pendingTask()
            self.tableView.reloadData()
            self.height?.constant = 50*(CGFloat(self.vm.count))
            self.showNoTask(totalTasks: self.vm.pendingCount)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.cancelAction, style: .default , handler:{ (UIAlertAction)in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    private func showNoTask(totalTasks: Int){
        if totalTasks == 0{
            addTask.isHidden = false
        }
        else{
            addTask.isHidden = true
        }
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
        
        //On tap of complete
        cell.completedTapped = {
            if todo.completedTask == false {
                self.vm.completeTaskAtIndex(indexPath.row) { (_) in
                    tableView.reloadData()
                }
            }
        }
        
        //On tap of delete
        cell.deletedTapped = {
            let alertController = UIAlertController(title: StringConstants.alert, message: StringConstants.deleteWarning, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: StringConstants.yes, style: .default, handler: { (_) in
                self.vm.deleteTask(indexPath.row) { (_) in
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                self.tableView.reloadData()
                self.height?.constant = 50*(CGFloat(self.vm.count))
                if self.vm.count == 0{
                    self.addTask.isHidden = false
                }
                else{
                    self.addTask.isHidden = true
                }
            }))
            alertController.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
        return cell
    }
    
}
