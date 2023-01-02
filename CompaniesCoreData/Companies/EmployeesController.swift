//
//  EmployeesController.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 02/01/2023.
//

import UIKit

class EmployeesController: UITableViewController {
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .blue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    @objc func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}
