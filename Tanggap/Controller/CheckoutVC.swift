//
//  CheckoutVC.swift
//  Tanggap
//
//  Created by Veber on 10/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class CheckoutVC: UIViewController {
    
    var requesterPost: userDetail?
    var requesterName = ""
    var requesterAddr = ""
    var requesterPhoneNum = ""
    var requesterDesc = ""
    var amountOfQtyGiven = 0
    let db = Firestore.firestore().collection("userDetail")
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var qtyTextLabel: UILabel!
    @IBOutlet weak var qtyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextLabel.text = requesterPhoneNum
        qtyTextLabel.text = String(amountOfQtyGiven)
    }

    @IBAction func updateBtnPressed(_ sender: Any) {
        uploadEditedDoc()
    }
    
    func uploadEditedDoc(){
        let amountOfQtyInput = qtyTextField.text!
        let amountOfQtyInt = Int(amountOfQtyInput)!
        let newAmountOfQty = amountOfQtyGiven - amountOfQtyInt
        
        db.document("UofwLdvWYPB5FYr3YmzN").updateData([
            "qty": newAmountOfQty,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
    }
    
}
