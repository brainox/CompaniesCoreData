//
//  CreateEmployeeController.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 02/01/2023.
//

import UIKit


class CreateEmployeeController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Employees"
        view.backgroundColor = .darkBlue
        setupCancelButtonInNavBar()
        _ = setupLightBlueBackgroundView(height: 50)
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }
    
    @objc func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        let error = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        if let error = error {
            print(error)
        }
        dismiss(animated: true)
    }
}
