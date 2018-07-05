//
//  TodoViewController.swift
//  TodoList
//
//  Created by Astitv Nagpal on 7/5/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var todoList: [String] = ["Do Laundry", "Buy Grocery", "Car Servicing"]
    var valueToPass: String!
    var todoList: [NSManagedObject] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.delegate = self
        //tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TodoItem")
        
        do {
            todoList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        //cell.textLabel?.text = self.todoList[indexPath.row]
        let todoItem = todoList[indexPath.row]
        cell.textLabel?.text = todoItem.value(forKeyPath: "name") as? String;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let alert = UIAlertController(title: "Cell Tapped", message: "You tapped \(indexPath.row)", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        self.valueToPass = currentCell.textLabel?.text
        print("Value To pass on row selection \(self.valueToPass)")
        self.performSegue(withIdentifier: "cellData", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "cellData") {
            let viewController = segue.destination as! TodoDataViewController
            viewController.passedValue = self.valueToPass
        }
    }
    
    @IBAction func addTodoItemClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add TODO", message: "Please enter your TODO Item !", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let todoTextField = alertController.textFields?[0] {
                if(todoTextField.text != "") {
                    self.save(name: todoTextField.text!)
                    self.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "todo item"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "TodoItem",
                                       in: managedContext)!
        
        let todoItem = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        todoItem.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            todoList.append(todoItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
