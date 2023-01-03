//
//  CoreDataManager.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 26/12/2022.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer =  {
        let container = NSPersistentContainer(name: "CompanyCoreData")
        container.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
            return []
        }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            return nil
        } catch let err {
            print("Failed to create employee:", err)
            return err
        }
    }
}
