//
//  CreateCompanyController.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 21/12/2022.
//

import UIKit
import CoreData

protocol CreateCompanyCompanyDelegate: AnyObject {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyCompany: UIViewController{
    weak var delegate: CreateCompanyCompanyDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)

            }
            guard let founded = company?.founded else { return }
            datePicker.date = founded
            
        }
    }
    
    private lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_photo_empty")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.darkBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCircularImageStyle()
    }
    
    private func setupUI() {
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        view.addSubview(companyImageView)
        
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
    }
    
    private func setupCircularImageStyle() {
         companyImageView.layer.cornerRadius = companyImageView.frame.width/2
         companyImageView.clipsToBounds = true
         companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
         companyImageView.layer.borderWidth = 2
     }

    func createCompany() {
        // Initialization of the Core data stack
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.7)
            company.setValue(imageData, forKey: "imageData")
        }
        
        // perform the save
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveErr {
            print("Failed to save company: \(saveErr)")
        }
    }
    
    func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.7)
            company?.imageData = imageData
        }
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveErr {
            print("Failed to save company: \(saveErr)")
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
}

extension CreateCompanyCompany: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        setupCircularImageStyle()
        dismiss(animated: true)
    }
}
