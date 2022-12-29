//
//  CompanyController+CreateCompany.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 29/12/2022.
//

import UIKit

extension CompaniesController: CreateCompanyDelegate {
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

