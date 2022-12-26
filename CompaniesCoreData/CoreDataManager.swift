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
}
