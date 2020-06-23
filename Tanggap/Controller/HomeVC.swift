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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var feedArr: [requesterDetail] = []
    var filteredData: [requesterDetail]!
    var isFiltering = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.dataSource = self
        theTableView.delegate = self
        searchBar.delegate = self
        theTableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        filteredData = feedArr
        fetchDocumentFB()
    }
    
    func fetchDocumentFB(){
        //Only Fetch Doc From FB. Not Shown.
        db.collection("requesterDetail").order(by: "time", descending: true).addSnapshotListener { (querySnapshot, error) in
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

extension HomeVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            updateSearchResults(searchText: searchText)
        }

    func updateSearchResults(searchText: String) {
        if searchText.isEmpty {
            filteredData = feedArr
            isFiltering = false
        } else {
            filteredData = feedArr.filter{$0.desc.range(of: searchText, options: .caseInsensitive) != nil }
            isFiltering = true
        }
        theTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return isFiltering ? filteredData.count : feedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = theTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        let cellFiltered = isFiltering ? filteredData[indexPath.row] : feedArr[indexPath.row]
        cell.nameTextField.text = cellFiltered.name
        cell.addrTextField.text = cellFiltered.addr
        cell.descTextField.text = cellFiltered.desc
        cell.amountOfQtyTextField.text = String(cellFiltered.qty)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPost = feedArr[indexPath.row]
        performSegue(withIdentifier: "toRequestDetailSegue", sender: selectedPost)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
