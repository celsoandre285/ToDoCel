//
//  TodoListViewController.swift
//  TODOCel
//
//  Created by Celso Lima on 21/02/20.
//  Copyright © 2020 Celso Lima. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController:  UITableViewController {
    
    private let listTodoKey   = "listTodoItems"
    private let itemCellKey   = "ToDoItemCell"
    private let itensPlistKey = "Items.plist"
    private let dataBaseName  = "DataModel"
    
    var itens = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItens()
        }
    }
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.navitationBarSettings()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK - navitationBar settings
    func navitationBarSettings() {
        let nav = self.navigationItem
        nav.title = "ToDo List"
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
        
        saveContext()
        
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
            
            
            let newItem = Item(context: self.persistentContainer.viewContext)
            newItem.title = text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itens.append(newItem)
            
            self.saveContext()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataBaseName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    // MARK: - Core Data Manipulation
    func saveContext(){
       
        do {
            try persistentContainer.viewContext.save()
        
        } catch {
            let nsError = error
            print("Unresolved error \(nsError.localizedDescription) ")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItens(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let predicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
        } else {
            
        }

        request.predicate = categoryPredicate
        
        do {
            itens = try persistentContainer.viewContext.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data from \(error)")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            loadItens()
            return
        }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        
        //request.predicate = predicate
        
        let sortDescripter = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescripter]
        
        loadItens(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let test = searchBar.text, test.isEmpty {
            loadItens()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

extension TodoListViewController: UIPickerViewDelegate, UIImagePickerControllerDelegate {}

