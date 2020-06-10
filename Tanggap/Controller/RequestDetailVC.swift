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
    
    var postForm: userDetail?
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
        
    }
    
    
}
