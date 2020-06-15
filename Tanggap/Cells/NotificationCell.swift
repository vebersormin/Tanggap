//
//  NotificationCell.swift
//  Tanggap
//
//  Created by Veber on 15/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var donationMethodTextField: UILabel!
    @IBOutlet weak var amountGivenTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(configDonorDetail: donorDetail){
        nameTextField.text = configDonorDetail.name
        donationMethodTextField.text = configDonorDetail.typeOfDonationMethod
        amountGivenTextField.text = String(configDonorDetail.donationGiven)
    }
    
}
