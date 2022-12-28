//
//  companyCell.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 28/12/2022.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    private lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(companyImageView)
        
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
