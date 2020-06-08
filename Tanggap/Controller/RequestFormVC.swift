//
//  RequestFormVC.swift
//  Tanggap
//
//  Created by Veber on 08/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class RequestFormVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var descBoxField: UITextView!
    @IBOutlet weak var amountOfQtyTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var requesterName = ""
    var requesterAddr = ""
    var requesterPhoneNum = 0
    var requesterDesc = ""
    var qtyAmount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postRequestBtnPressed(_ sender: Any) {
        uploadDocsToFb()
    }
    
    
    func uploadDocsToFb(){
        
        guard let name = nameTextField.text, name.isNotEmpty,
            let address = addressTextField.text, address.isNotEmpty,
            let desc = descBoxField.text, desc.isNotEmpty,
            let phoneString = phoneTextField.text, phoneString.isNotEmpty,
            let phone = Int(phoneString),
            let amountOfQtyString = amountOfQtyTextField.text, amountOfQtyString.isNotEmpty,
            let amountOfQty = Int(amountOfQtyString) else {
                
                simpleAlert(title: "Missing Field", msg: "Please Fill All Field Correctly")
                return
        }
        
        self.requesterName = name
        self.requesterAddr = address
        self.requesterPhoneNum = phone
        self.requesterDesc = desc
        self.qtyAmount = amountOfQty
        
        uploadDocs()
        
    }
    
    func uploadDocs(){
        db.collection("userDetail").addDocument(data: ["name" : requesterName
        , "addr" : requesterAddr
        , "phone" : requesterPhoneNum
        , "desc" : requesterDesc
        , "qty" : qtyAmount
        , "time" : Timestamp()]) { (error) in
                
            if let e = error {
                self.simpleAlert(title: "Error", msg: "\(e)")
            }else {
                self.simpleAlert(title: "Success", msg: "Your Request Form Has Been Posted Succesfully")
            }
        }
    }
}
