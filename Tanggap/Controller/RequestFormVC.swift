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
    var requesterPhoneNum = ""
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
            let phone = phoneTextField.text, phone.isNotEmpty,
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
        let opportunityCollection = db.collection("requesterDetail")
        let newDocumentID = UUID().uuidString
        let passAuthPhone = Const.FStore.requesterAuthNum!
        let opportunityDocument = opportunityCollection.document(newDocumentID)
        let passName = requesterName
        let passAddr = requesterAddr
        let passPhone = requesterPhoneNum
        let passDesc = requesterDesc
        let passQty = qtyAmount
                
        let data: [String: Any] = ["id": newDocumentID,
                                   "name": passName,
                                   "authPhone": passAuthPhone,
                                   "addr": passAddr,
                                   "phone": passPhone,
                                   "desc": passDesc,
                                   "qty": passQty,
                                   "time": Timestamp()]
        
        opportunityDocument.setData(data) { (error) in
            if let error = error {
                self.simpleAlert(title: "Error", msg: "\(error)")
            } else {
                print("Data Saved")
                self.toFinishScreen()
            }
        }
    }
    
    @objc func toFinishScreen (){
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finishScreenStoryboard")
        
        sb.modalPresentationStyle = .fullScreen
        
        self.present(sb, animated: true, completion: nil)
    }
}
