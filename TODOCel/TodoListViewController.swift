//
//  TodoListViewController.swift
//  TODOCel
//
//  Created by Celso Lima on 21/02/20.
//  Copyright © 2020 Celso Lima. All rights reserved.
//

import UIKit

class TodoListViewController:  UITableViewController {
    
    private let listTodoKey = "listTodoItems"
    private let itemCellKey = "ToDoItemCell"
    private let itensPlistKey = "Items.plist"
    
    var itens = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        print("Data file Path \(dataFilePath)")
        
//        itens.append( Item(title: "Celso") )
//        itens.append( Item(title: "André") )
       
//        if let itens = defaults.array(forKey: self.listTodoKey) as? [String] {
//            self.itemArray = itens
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItens()
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
        
        saveItens()
        
        tableView.deselectRow(at: indexPath, animated: true)
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
            
            self.saveItens()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItens(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itens)
            try data.write(to: self.dataFilePath!)
            
        } catch {
            print("error encoding item array, \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItens() {
        
        if let data = try? Data(contentsOf: self.dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itens = try decoder.decode([Item].self, from: data )
            }catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
}

