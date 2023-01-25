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
        view.backgroundColor = .systemBackground
        self.companies = CoreDataManager.shared.fetchCompanies()
        setUpNavigationStyle()
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    }
    
    func setUpNavigationStyle() {
        navigationItem.title = "Companies"
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
    
    @objc func doWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    self.companies  = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save:", err)
            }
        }
    }
    
    @objc func doUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(fetchRequest)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                }
                
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed to save on background:", err)
                }
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
        }
    }
}
