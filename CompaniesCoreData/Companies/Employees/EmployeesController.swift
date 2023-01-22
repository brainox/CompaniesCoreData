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
    let cellID = "employeeCellId"
    
   
    var allEmployees = [[Employee]]()
    
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
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
    private func fetchEmployees() {
        guard let companyEmployees = self.company?.employees?.allObjects as? [Employee] else {
            return
        }
        
        allEmployees = []
        
        employeeTypes.forEach { employeeType in
            //   appending the employeeTypes to allEmployee
            allEmployees.append(
                companyEmployees.filter({ $0.type == employeeType })
            )

        }

//        let executives = companyEmployees.filter { (employee) in
//            return employee.type == EmployeeType.Executive.rawValue}
//
//        let seniorManagement = companyEmployees.filter { return $0.type ==  EmployeeType.SeniorManagement.rawValue}
//
//        let staff = companyEmployees.filter { return $0.type == EmployeeType.Staff.rawValue}
//
//        allEmployees = [
//            executives,
//            seniorManagement,
//            staff
//        ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
//        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let birthday = employee.employeeInformation?.birthday {
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormatter.string(from: birthday))"
        }
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        let label = IndentedLabels()
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    @objc func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = self.company
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
//        employees.append(employee)
//        fetchEmployees()
//        tableView.reloadData()
        
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        
        let row = allEmployees[section].count
        
        let insertionIndex = IndexPath(row:row, section: section)
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndex], with: .middle)
    }
    
    
}
