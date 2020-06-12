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
    @IBOutlet weak var addrTextField: UILabel!
    @IBOutlet weak var descTextField: UILabel!
    @IBOutlet weak var amountOfQtyTextField: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func donateBtnPressed(_ sender: Any) {
        
    }
    
    
    func configCell(configUserDetail: requesterDetail){
        nameTextField.text = configUserDetail.name
        addrTextField.text = configUserDetail.addr
        descTextField.text = configUserDetail.desc
        amountOfQtyTextField.text = String(configUserDetail.qty)
    }
    
}
