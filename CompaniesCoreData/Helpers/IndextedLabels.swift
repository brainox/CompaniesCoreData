//
//  IndextedLabels.swift
//  CompaniesCoreData
//
//  Created by Obinna Aguwa on 14/01/2023.
//

import UIKit

class IndentedLabels: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRects = rect.inset(by: insets)
        super.drawText(in: customRects)
    }
}
