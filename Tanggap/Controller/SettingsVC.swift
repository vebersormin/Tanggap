//
//  SettingsVC.swift
//  Tanggap
//
//  Created by Veber on 17/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        toHomeScreen()
    }
    
    @objc func toHomeScreen(){
        try! Auth.auth().signOut()
        
        let sb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMainScreenStoryboard")
        
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: false, completion: nil)
    }
}
