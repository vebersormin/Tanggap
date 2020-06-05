//
//  PhoneRegisterVC.swift
//  Tanggap
//
//  Created by Veber on 05/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class PhoneRegisterVC: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerNumberTextField: UITextField!
    
    var userFullName = ""
    var userEmail = ""
    var userPhoneNumber = 0
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        requestToFb()
    }
    
    
    func requestToFb(){
        guard let fullName = fullNameTextField.text, fullName.isNotEmpty,
            let email = emailTextField.text, email.isNotEmpty,
            let registerNumberString = registerNumberTextField.text, registerNumberString.isNotEmpty,
            let registerNumber = Int(registerNumberString) else {
                simpleAlert(title: "Missing Information", msg: "Please Fill All Fields Correctly")
                return
        }
        
        self.userFullName = fullName
        self.userEmail = email
        self.userPhoneNumber = registerNumber
        
        self.uploadToFb()
    }
    
    func uploadToFb(){
        db.collection("RegisterUser").addDocument(data:
            [Const.FStore.nameField: userFullName,
             Const.FStore.emailField: userEmail,
             Const.FStore.newPhoneField: userPhoneNumber]) {
                (error) in
                if let err = error {
                    self.simpleAlert(title: "Firestore Error", msg: "\(err)")
                }else{
                    print("Data Saved To Firestore")
                }
        }
    }
}
