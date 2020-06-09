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
        
    }
    
    
    @IBAction func donateNowBtnPressed(_ sender: Any) {
        
    }
    
    
}
