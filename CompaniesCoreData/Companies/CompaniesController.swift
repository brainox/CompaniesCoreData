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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteActionFunction(indexPath), editActionFunction(indexPath)])
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
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
    
    func setUpNavigationStyle() {
        navigationItem.title = "Companies"
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
    
    @objc func handleAddCompany() {
        let createCompanyCompany = CreateCompanyCompany()
        let navController = CustomNavigationController(rootViewController: createCompanyCompany)
        navController.modalPresentationStyle = .fullScreen
        createCompanyCompany.delegate = self
        present(navController, animated: true)
    }
    
    @objc func handleReset() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
//            tableView.reloadData()
        } catch let delErr {
            print("Failed to delete objects from Core Data: \(delErr)" )
        }
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
