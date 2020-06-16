//
//  NotificationVC.swift
//  Tanggap
//
//  Created by Veber on 15/06/20.
//  Copyright © 2020 Veber. All rights reserved.
//

import UIKit
import Firebase

class NotificationVC: UIViewController {
    
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    let db = Firestore.firestore()
    var notifArr: [donorDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        
        notificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        fetchDocumentFromFb()
    }
    
    func fetchDocumentFromFb(){
        
        db.collection("donorDetail").whereField("forWho", isEqualTo: Const.FStore.requesterAuthNum!).getDocuments { (querySnapshot, error) in
            self.notifArr = []
            
            if let error = error{
                print("There was an error with Firestore. \(error)")
            }
            else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let donorId = data["id"] as? String,
                        let forWho = data["forWho"] as? String,
                        let donorDonationMethod = data["typeOfDonationMethod"] as? String,
                        let requestFormOf = data["requestFormOf"] as? String,
                        let donorName = data["name"] as? String,
                        let linkDonation = data["linkDonation"] as? String,
                        let donationGiven = data["donationGiven"] as? Int,
                        let timeStamp = data["time"] as? Timestamp {
                            
                            let newDonorDetail = donorDetail(id: donorId, forWho: forWho, typeOfDonationMethod: donorDonationMethod, requestFormOf: requestFormOf, name: donorName, linkDonation: linkDonation, donationGiven: donationGiven, time: timeStamp)
                            
                            self.notifArr.append(newDonorDetail)
                            print("\(doc.documentID)")
                            DispatchQueue.main.async {
                                self.notificationTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }

    }
}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell {
            
            cell.configureCell(configDonorDetail: notifArr[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
