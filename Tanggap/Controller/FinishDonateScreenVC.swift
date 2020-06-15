//
//  FinishDonateScreenVC.swift
//  Tanggap
//
//  Created by Veber on 12/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit

class FinishDonateScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func goToHomeScreenBtnPressed(_ sender: Any) {
        goToHomeScreen()
    }
    
    @objc func goToHomeScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "homeStoryboard")
        sb.tabBarController?.tabBar.isHidden = false
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: true, completion: nil)
    }
}
