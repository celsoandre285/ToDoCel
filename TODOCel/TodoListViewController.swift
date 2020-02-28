//
//  TodoListViewController.swift
//  TODOCel
//
//  Created by Celso Lima on 21/02/20.
//  Copyright © 2020 Celso Lima. All rights reserved.
//

import UIKit

class TodoListViewController:  UITableViewController {
    
    var itens = [Item]()
    let defaults = UserDefaults.standard
    private let listTodoKey = "listTodoItems"
    private let itemCellKey = "ToDoItemCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        itens.append( Item(title: "Celso") )
        itens.append( Item(title: "André") )
       
        
        
        
//        if let itens = defaults.array(forKey: self.listTodoKey) as? [String] {
//            self.itemArray = itens
//        }
    }
    
    //MARK - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellKey, for: indexPath)
        let item = itens[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itens[indexPath.row].done = !itens[indexPath.row].done
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("item selecionado: \(itens[indexPath.row].title)")
    }
    
    //MARK: - Actions

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add novo Item!")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add novo TODO Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add novo Item", style: .default) { (action) in
            guard let text = textField.text, !text.isEmpty else {
                self.showToast(message: "nada foi digitado")
                return }
            
            let newItem = Item(title: text)
            
            self.itens.append(newItem)
//
//            self.defaults.set(self.itemArray, forKey: self.listTodoKey)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
}

