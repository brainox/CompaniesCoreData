//
//  CompaniesController.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 21/12/2022.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCompanies()
        view.backgroundColor = .systemBackground
        setUpNavigationStyle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func fetchCompanies() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            companies = try context.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyCompany = CreateCompanyCompany()
        let navController = CustomNavigationController(rootViewController: createCompanyCompany)
        navController.modalPresentationStyle = .fullScreen
        createCompanyCompany.delegate = self
        present(navController, animated: true)
    }
    
    func setUpNavigationStyle() {
        navigationItem.title = "Companies"
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteActionFunction(indexPath), editActionFunction(indexPath)])
        return swipeActions
    }
    
    func deleteActionFunction(_ indexPath: IndexPath) -> UIContextualAction {
        let deleteActionContextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let company = self.companies[indexPath.row]
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the company from coredata
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to save company: \(saveErr)")
            }
        }
        deleteActionContextItem.backgroundColor = .lightRed
        return deleteActionContextItem
    }
    
    func editActionFunction(_ indexPath: IndexPath) -> UIContextualAction {
        let editActionContextItem = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, boolValue) in
            let editCompanyController = CreateCompanyCompany()
            editCompanyController.delegate = self
            editCompanyController.company = self.companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
        editActionContextItem.backgroundColor = .darkBlue
        return editActionContextItem
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.tealColor
        
        let company = companies[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        // Configure content
        if let name = company.name, let founded = company.founded {
            
//            "MMM dd, yyyy"
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MMM dd, yyyy"
            
            let foundedDateString = dateFormater.string(from: founded)
//            let locale = Locale(identifier: "EN")
            let dateString = "\(name) - Founded: \(foundedDateString)"
            content.text = dateString
        } else {
            content.text = company.name
        }
        content.textProperties.color = .white
        content.textProperties.font = .boldSystemFont(ofSize: 16)
        content.image = UIImage(named: "select_photo_empty")
        if let imageData = company.imageData {
            content.image = UIImage(data: imageData)
        } 
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.imageProperties.cornerRadius = 25
       
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}

extension CompaniesController: CreateCompanyCompanyDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)!
        let reloadIndex = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [reloadIndex], with: .middle)
    }
}
