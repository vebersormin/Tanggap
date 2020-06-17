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
    
    func checkUsername(field: Int, completion: @escaping (Bool) -> Void) {
        let collectionRef = db.collection("RegisterUser")
        collectionRef.whereField("newPhoneNumber", isEqualTo: field).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["newPhoneNumber"] != nil {
                        completion(true)
                    }
                }
            }
        }
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
        
        self.checkUsername(field: userPhoneNumber) { (success) in
            if success == true {
                print("Phone Number has been registered")
                self.simpleAlert(title: "Phone Number Has Been Registered", msg: "Please Login or Insert a Different Number")
            } else {
                self.uploadToFb()
            }
        }
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
                    self.toLoginScreen()
                }
        }
    }
    
    @objc func toLoginScreen(){
        try! Auth.auth().signOut()
        
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toLoginScreenStoryboard")
        
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: true, completion: nil)
    }
}
