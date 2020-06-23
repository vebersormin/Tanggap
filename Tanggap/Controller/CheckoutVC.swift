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
    
    //variable from requestDetail
    var requesterPost: requesterDetail?
    var requesterName = ""
    var requesterId = ""
    var requesterPhoneAuth = ""
    var requesterAddr = ""
    var requesterPhoneNum = ""
    var requesterDesc = ""
    var amountOfQtyNeeded = 0
    let db = Firestore.firestore().collection("requesterDetail")
    
    
    //outlet
    @IBOutlet weak var senderGojekTextField: UITextField!
    @IBOutlet weak var trackingGoSendTextField: UITextField!
    @IBOutlet weak var amountGosendTextField: UITextField!
    
    @IBOutlet weak var senderGrabTextField: UITextField!
    @IBOutlet weak var trackingGrabTextField: UITextField!
    @IBOutlet weak var amountGrabTextField: UITextField!

    @IBOutlet weak var transferProofTextField: UITextField!
    @IBOutlet weak var senderTransferTextField: UITextField!
    @IBOutlet weak var amountDonationTextField: UITextField!
    
    
    
    //variable for Sender Info
    var sender = ""
    var track = ""
    var amount = 0
    var theDonationMethod = "Untuk Alternative"
    let database = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func confirmGosendBtnPressed(_ sender: Any) {
        checkMissingField(sender: senderGojekTextField, tracker: trackingGoSendTextField, amountQty: amountGosendTextField, method: "Gosend")
        editAmountOfQtyGosend(amount: amount)
    }
    
    
    @IBAction func confirmGrabBtnPressed(_ sender: Any) {
        checkMissingField(sender: senderGrabTextField, tracker: trackingGrabTextField, amountQty: amountGrabTextField, method: "Grab Express")
        editAmountOfQtyGrab(amount: amount)
    }
    
    
    @IBAction func confirmTransferBtnPressed(_ sender: Any) {
        checkMissingField(sender: senderTransferTextField, tracker: transferProofTextField, amountQty: amountDonationTextField, method: "Transfer / M-Banking")
        editAmountOfQtyGrab(amount: amount)
    }
    
    func editAmountOfQtyGrab(amount: Int){
        
        let amountOfQtyInput = amount
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInput
        
        if newAmountOfQty < 0 {
            simpleAlert(title: "The amount of donation is too much", msg: "Please donate not more than \(amountOfQtyNeeded)")
        }
        else if amountOfQtyInput == 0 {
            simpleAlert(title: "Number invalid", msg: "Number 0 detected, Please insert a valid number")
        }
        else{
            db.document(requesterId).updateData(["qty" : newAmountOfQty]) { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.uploadDonorDocsToFB(amountOfQty: amountOfQtyInput)
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func editAmountOfQtyGosend(amount: Int){
        
        let amountOfQtyInput = amount
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInput
        
        if newAmountOfQty < 0 {
            simpleAlert(title: "The amount of donation is too much", msg: "Please donate not more than \(amountOfQtyNeeded)")
        }
        else if amountOfQtyInput == 0 {
            simpleAlert(title: "Number invalid", msg: "Number 0 detected, Please insert a valid number")
        }
        else{
            db.document(requesterId).updateData(["qty" : newAmountOfQty]) { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.uploadDonorDocsToFB(amountOfQty: amountOfQtyInput)
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func editAmountOfQtyTransfer(amount: Int){
        
        let amountOfQtyInput = amount
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInput
        
        if newAmountOfQty < 0 {
            simpleAlert(title: "The amount of donation is too much", msg: "Please donate not more than \(amountOfQtyNeeded)")
        }
        else if amountOfQtyInput == 0 {
            simpleAlert(title: "Number invalid", msg: "Number 0 detected, Please insert a valid number")
        }
        else{
            db.document(requesterId).updateData(["qty" : newAmountOfQty]) { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.uploadDonorDocsToFB(amountOfQty: amountOfQtyInput)
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func uploadDonorDocsToFB(amountOfQty: Int){
        
        let amountOfQtyInput = amountOfQty
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInput
        
        if newAmountOfQty == 0{
            deleteDocs()
            uploadDonorDocs()
        }else {
            uploadDonorDocs()
        }
    }
    
    func uploadDonorDocs(){
        let collection = database.collection("donorDetail")
        let newDocsId = UUID().uuidString
        let collectionDocument = collection.document(newDocsId)
        let passRequestFormOf = requesterDesc
        let passForWho = requesterPhoneAuth
        let passDonationMethod = theDonationMethod
        let passName = sender
        let passLink = track
        let passDonationQty = amount
        
        let data: [String: Any] = ["id": newDocsId,
                                   "forWho": passForWho,
                                   "requestFormOf": passRequestFormOf,
                                   "typeOfDonationMethod": passDonationMethod,
                                   "name": passName,
                                   "linkDonation": passLink,
                                   "donationGiven": passDonationQty,
                                   "time": Timestamp()]
        
        collectionDocument.setData(data) { (error) in
            if let error = error {
                self.simpleAlert(title: "Error", msg: "\(error)")
            } else {
                print("Data Saved")
                self.toFinishScreen()
            }
        }
    }
    
    func deleteDocs(){
        let collectionDocument = db.document(requesterId)
        collectionDocument.delete()
    }
    
    func checkMissingField(sender: UITextField, tracker: UITextField, amountQty: UITextField, method: String){
                
        guard let sender = sender.text, sender.isNotEmpty,
            let trackLink = tracker.text, trackLink.isNotEmpty,
            let amountString = amountQty.text, amountString.isNotEmpty,
            let amount = Int(amountString)
            else {
                simpleAlert(title: "Missing Field", msg: "Please Fill All Fields Correctly")
                return
            }
            self.sender = sender
            self.track = trackLink
            self.amount = amount
            self.theDonationMethod = method
    }
    
    @objc func toFinishScreen (){
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toFinishDonateStoryboard")
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: true, completion: nil)
    }
    
}
