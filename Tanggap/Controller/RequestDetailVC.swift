//
//  RequestDetailVC.swift
//  Tanggap
//
//  Created by Veber on 09/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit

class RequestDetailVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descBoxTextField: UITextView!
    @IBOutlet weak var QtyTextField: UITextField!
    
    var postForm: requesterDetail?
    var idText = ""
    var nameText = ""
    var authPhoneText = ""
    var addressText = ""
    var descBoxText = ""
    var phoneText = ""
    var qtyText = 0
    
    let application = UIApplication.shared
    let urlSchema = "tel:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        nameTextField.text = postForm?.name
        addressTextField.text = postForm?.addr
        QtyTextField.text = String(postForm!.qty)
        descBoxTextField.text = postForm?.desc
    }
    
    @IBAction func callBtnPressed(_ sender: Any) {
        guard let phoneURL = URL(string: "\(urlSchema)\(postForm!.phone)")
            else {return}
        if application.canOpenURL(phoneURL) {
            application.open(phoneURL, options: [:], completionHandler: nil)
        }else{
            simpleAlert(title: "Phone Number Not Avail.", msg: "Cannot Call Requester")
        }
    }
    
    
    @IBAction func donateNowBtnPressed(_ sender: Any) {
        //set data to passed in func prepare for segue
        self.nameText = nameTextField.text!
        self.idText = postForm!.id
        self.authPhoneText = postForm!.authPhone
        self.addressText = postForm!.addr
        self.descBoxText = postForm!.desc
        self.phoneText = postForm!.phone
        self.qtyText = Int(QtyTextField.text!)!
        performSegue(withIdentifier: "toCheckoutSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheckoutSegue" {
            let destVC = segue.destination as! CheckoutVC
            destVC.requesterName = self.nameText
            destVC.requesterId = self.idText
            destVC.requesterPhoneAuth = self.authPhoneText
            destVC.requesterAddr = self.addressText
            destVC.requesterDesc = self.descBoxText
            destVC.requesterPhoneNum = self.phoneText
            destVC.amountOfQtyNeeded = self.qtyText
        }
        
    }
    
    
}
