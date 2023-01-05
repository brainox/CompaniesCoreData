//
//  EmployeesController.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 02/01/2023.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    var company: Company?
    var employees = [Employee]()
    let cellID = "employeeCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(fetchRequest)
            self.employees = employees
        }catch let err {
            print("Failed to fetch employees:", err)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    @objc func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    
}
