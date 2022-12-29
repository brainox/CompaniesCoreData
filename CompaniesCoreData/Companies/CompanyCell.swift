//
//  companyCell.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 28/12/2022.
//

import UIKit

class CompanyCell: UITableViewCell {
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            if let name = company?.name, let founded = company?.founded {

    //            "MMM dd, yyyy"
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MMM dd, yyyy"

                let foundedDateString = dateFormater.string(from: founded)
    //            let locale = Locale(identifier: "EN")
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    private lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
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
        backgroundColor = .tealColor
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(companyImageView)
        addSubview(nameFoundedDateLabel)
        
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameFoundedDateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: companyImageView.trailingAnchor, multiplier: 1).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nameFoundedDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
