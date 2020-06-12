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
    
    //variable for Gosend
    var sender = ""
    var track = ""
    var amount = 0
    let database = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func confirmGosendBtnPressed(_ sender: Any) {
        editAmountOfQty(amount: amountGosendTextField)
        uploadDonorDocsToFB(sender: senderGojekTextField, tracker: trackingGoSendTextField, amountQty: amountGosendTextField)
    }
    
    
    @IBAction func confirmGrabBtnPressed(_ sender: Any) {
        editAmountOfQty(amount: amountGrabTextField)
    }
    
    func editAmountOfQty(amount: UITextField){
        
        let amountOfQtyInput = amount.text!
        let amountOfQtyInt = Int(amountOfQtyInput)!
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInt
        
        if newAmountOfQty < 0 {
            simpleAlert(title: "The amount of donation is too much", msg: "Please donate not more than \(amountOfQtyNeeded)")
        }
        else{
            db.document(requesterId).updateData([
                "qty": newAmountOfQty,
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.uploadDonorDocsToFB(sender: self.senderGrabTextField, tracker: self.trackingGrabTextField, amountQty: self.amountGrabTextField)
                        print("Document successfully updated")
                    }
            }
        }
    }
    
    func uploadDonorDocsToFB(sender: UITextField, tracker: UITextField, amountQty: UITextField){
        
        let amountOfQtyInput = amountQty.text!
        let amountOfQtyInt = Int(amountOfQtyInput)!
        let newAmountOfQty = amountOfQtyNeeded - amountOfQtyInt
        
        guard let sender = sender.text, sender.isNotEmpty,
            let trackLink = tracker.text, trackLink.isNotEmpty,
            let amountString = amountQty.text, amountString.isNotEmpty,
            let amount = Int(amountString) else {
                
                simpleAlert(title: "Missing Field", msg: "Please Fill All Fields Correctly")
                return
        }
        self.sender = sender
        self.track = trackLink
        self.amount = amount
        
        if newAmountOfQty == 0{
            uploadDonorDocs()
            deleteDocs()
        }else {
            uploadDonorDocs()
        }
    }
    
    func uploadDonorDocs(){
        let collection = database.collection("donorDetail")
        let newDocsId = UUID().uuidString
        let collectionDocument = collection.document(newDocsId)
        let passForWho = requesterPhoneAuth
        let passName = sender
        let passLink = track
        let passDonationQty = amount
        
        let data: [String: Any] = ["id": newDocsId,
                                   "forWho": passForWho,
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
    
    @objc func toFinishScreen (){
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toFinishDonateStoryboard")
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: true, completion: nil)
    }
    
}
