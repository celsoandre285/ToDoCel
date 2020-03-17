//
//  CategoryTableViewController.swift
//  TODOCel
//
//  Created by Celso Lima on 12/03/20.
//  Copyright © 2020 Celso Lima. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    private let categoryCellKey = "categoryCell"
    private let goToItems = "goToItems"
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navitationBarSettings()
        self.loadCategories()
    }
    
    // MARK - navitationBar settings
    
    func navitationBarSettings() {
        let nav = self.navigationItem
        nav.title = "Category List"
    }

    // MARK: - Table view data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellKey, for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name ?? ""

        return cell
    }
    
    
    // MARK: - Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: goToItems, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == goToItems {
            let destinationVC = segue.destination as? TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC?.selectedCategory = categories[indexPath.row]
            }
            
        }
        
        
    }
    
    // MARK: - Data Manipulation Methods
    func saveContext(){
       
        do {
            try context.save()
        
        } catch {
            let nsError = error
            print("Unresolved error \(nsError.localizedDescription) ")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data from \(error)")
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add novo Item!")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add nova Categoria", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = textField.text, !text.isEmpty else {
                self.showToast(message: "nada foi digitado")
                return }
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = text
            
            self.categories.append(newCategory)
            
            self.saveContext()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
