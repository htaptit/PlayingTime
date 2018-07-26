//
//  AddressSavedViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 25/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import Unbox
import SJSegmentedScrollView

extension AddressSavedViewController: SJSegmentedViewControllerDelegate {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.tableView
    }
}

class AddressSavedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var socialUser: SocialUser?
    
    var addresses: MyApiConstacts?
    
    var tuples: [(name: String, email: String, type: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        
        self.getAddress()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("refreshContact"), object: nil)
    }
    
    @objc func refresh(_ notification: Notification) {
        self.tuples = []
        self.addresses = nil
        
        self.getAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getAddress() {
        guard let socialU = self.socialUser else {
            return
        }
        
        // call api
        
        let api = MyApi.getContacts(email: socialU.email, type: socialU.type.rawValue)
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let data: MyApiConstacts = try unbox(data: success.data)
                
                self.addresses = data
                
                self.getEmailByAddress(complete: {
                    self.tableView.reloadData()
                })
            } catch {
                
            }
        }, error: { (error) in
            
            print(error)
        }) { (fail) in
            
            print(fail)
        }
    }

    private func getEmailByAddress(complete: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let multiTask = DispatchGroup()
            
            var errorOccurred = false
            
            for (_, contact) in self.addresses!.constacts.enumerated() {
                multiTask.enter()
                
                MyApiAdap.request(target: MyApi.getEmailByAddress(address: contact.address), success: { (succes) in
                    do {
                        let data: MyApiParseEmailByAdress = try unbox(data: succes.data)
                        self.tuples.append((name: data.name, email: data.email, type: data.type))
                    } catch {
                        
                    }
                    
                    multiTask.leave()
                }, error: { (error) in
                    
                    errorOccurred = true
                    multiTask.leave()
                }, failure: { (fail) in
                    
                    errorOccurred = true
                    multiTask.leave()
                })
                
                // wait until entered task complete
                multiTask.wait()
                
                // breaking out of the loop if an error has occurred
                if errorOccurred { break }
            }
            
            if !errorOccurred {
                DispatchQueue.main.async {
                    complete()
                }
            }
        }
    }

}

extension AddressSavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.tuples = self.tuples[indexPath.row]
        return cell
    }
}

extension AddressSavedViewController: UITableViewDelegate {
    
}
