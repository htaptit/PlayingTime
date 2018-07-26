//
//  AddressPopularViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 25/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

extension AddressPopularViewController: SJSegmentedViewControllerDelegate {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.tableView
    }
}

class AddressPopularViewController: UIViewController {
    
    var socialUser: SocialUser?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
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
    }
    
}

extension AddressPopularViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        return cell
    }
}

extension AddressPopularViewController: UITableViewDelegate {
    
}
