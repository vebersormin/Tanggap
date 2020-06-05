//
//  DetailCell.swift
//  Tanggap
//
//  Created by Veber on 04/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var qtyTextField: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(configUserDetail: userDetail){
        nameTextField.text = configUserDetail.name
        qtyTextField.text = String(configUserDetail.qty)
    }
    
}
