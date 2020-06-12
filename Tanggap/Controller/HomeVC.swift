//
//  HomeVC.swift
//  Tanggap
//
//  Created by Veber on 05/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var theTableView: UITableView!
    
    let db = Firestore.firestore()
    var feedArr: [requesterDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.dataSource = self
        theTableView.delegate = self
        
        theTableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        fetchDocumentFB()
    }
    
    func fetchDocumentFB(){
        //Only Fetch Doc From FB. Not Shown.
        db.collection("requesterDetail").order(by: "name").addSnapshotListener { (querySnapshot, error) in
            self.feedArr = []
            
            if let e = error {
                print("\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let requesterId = data["id"] as? String,
                        let requesterName = data["name"] as? String,
                        let requesterAuthPhone = data["authPhone"] as? String,
                        let requesterDesc = data["desc"] as? String,
                        let requesterAddr = data["addr"] as? String,
                        let requesterPhone = data["phone"] as? String,
                        let amountOfQty = data["qty"] as? Int,
                        let timeStamp = data["time"] as? Timestamp {
                            
                            let newRequest = requesterDetail(id: requesterId, name: requesterName, authPhone: requesterAuthPhone, desc: requesterDesc, addr: requesterAddr, phone: requesterPhone, qty: amountOfQty, time: timeStamp)
                            
                            self.feedArr.append(newRequest)
                            print("\(doc.documentID)")
                            DispatchQueue.main.async {
                                self.theTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toRequestDetailSegue" {
            let destVC = segue.destination as! RequestDetailVC
            destVC.postForm = sender as? requesterDetail
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = theTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell {
            
            cell.configCell(configUserDetail: feedArr[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPost = feedArr[indexPath.row]
        performSegue(withIdentifier: "toRequestDetailSegue", sender: selectedPost)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
