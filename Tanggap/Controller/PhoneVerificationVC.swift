//
//  PhoneVerificationVC.swift
//  Tanggap
//
//  Created by Veber on 05/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class PhoneVerificationVC: UIViewController {
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var otpCodeTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    let userDefault = UserDefaults.standard
    var phoneNumber = 0
    var otpCode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func sendOtpBtnPressed(_ sender: Any) {
        phoneSendOtp()
    }
    
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        phoneInsertOtp()
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
    
    
    func phoneInsertOtp(){
        guard let otpCodeString = otpCodeTextField.text, otpCodeString.isNotEmpty,
            let otpCodeInt = Int(otpCodeString) else {
                simpleAlert(title: "OTP Code Missing", msg: "Please Insert OTP Code")
                return
        }
        self.otpCode = otpCodeInt
        
        let otpCodeInserted = otpCodeTextField.text
        
        let verificationID = userDefault.string(forKey: "authVerificationID")

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!,verificationCode: otpCodeInserted!)

        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                self.simpleAlert(title: "Wrong OTP", msg: "\(error.localizedDescription)")
                return
            }else{
                self.goToHomeScreen()
                print("Success")
            }
        }
    }
    
    func phoneSendOtp(){
        guard let phoneNumberInserted = phoneNumberTextField.text, phoneNumberInserted.isNotEmpty,
        let phoneNumberToInt = Int(phoneNumberInserted)
            else{
                simpleAlert(title: "Phone Number Is Empty", msg: "Please Fill Your Phone Number")
                return
        }
        self.phoneNumber = phoneNumberToInt
        
        self.checkUsername(field: phoneNumber) { (success) in
            if success == true {
                print("Username has been registered")
                PhoneAuthProvider.provider(auth: Auth.auth())

                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberInserted, uiDelegate: nil) { (verificationId, error) in
                    if(error != nil){
                        print("\(error!.localizedDescription)")
                    }else{
                        self.userDefault.set(verificationId, forKey: "authVerificationID")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
                    self.goToOtpScreen()
                })
            } else {
                self.simpleAlert(title: "New User Detected!☺️", msg: "Please Register First")
            }
        }
    }
        
    @objc func goToOtpScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let otpScreen = storyboard.instantiateViewController(withIdentifier: "otpStoryboard")
        self.present(otpScreen, animated: true, completion: nil)
    }
    
    @objc func goToHomeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "homeStoryboard")
        
        storyboard.modalPresentationStyle = .fullScreen
        
        self.present(storyboard, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
