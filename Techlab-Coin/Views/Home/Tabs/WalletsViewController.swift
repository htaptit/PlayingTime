//
//  ViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 6/29/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import Unbox

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var wallets: [Wallet] = [] {
        didSet {
            if let _ = tableView, !self.wallets.isEmpty {
                self.tableView.reloadData()
            }
        }
    }
    
    var social: SocialUser?
    
    var isCreateQRCode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isCreateQRCode ? "Create QRCode" : "Wallets" 
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.separatorStyle = .none
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        self.tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletTableViewCell")
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WalletsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.update(wallet: self.wallets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isCreateQRCode {
            return 50.0
        }
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isCreateQRCode {
            return "Please select address ! "
        }
        
        return nil
    }
}

extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        if self.isCreateQRCode {
            if let vc = main.instantiateViewController(withIdentifier: "QRCodeViewController") as? QRCodeViewController {
                vc.address = self.wallets[indexPath.row].address
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = main.instantiateViewController(withIdentifier: "AccountDetailViewController") as? AccountDetailViewController {
                vc.wallet = self.wallets[indexPath.row]
                vc.social = self.social
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension WalletsViewController: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return self.tableView
    }
}

