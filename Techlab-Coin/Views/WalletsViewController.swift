//
//  ViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 6/29/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit
import SJSegmentedScrollView

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // mark : variables
    let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
    
    var wallets: [Wallet] = []
    
    var isCreateQRCode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isCreateQRCode ? "Create QRCode" : "Wallets" 
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureTableView()
        
        self.getAccounts()
        
    }
    
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletTableViewCell")
    }
    
    private func getBalanceAccount(byAddress: String) {
        
    }
    
    private func getAccounts() {
        let request = EthGetAccounts()
        
        let batch = batchFactory.create(request)
        let httpRequest = EthServiceRequest(batch: batch)
        
        Session.send(httpRequest, callbackQueue: nil) { (result) in
            switch result {
            case .success(let result):
                for address in result {
                    let wallet: Wallet = Wallet(address: address, balance: nil)
                    self.wallets.append(wallet)
                }
                
                self.getBalance {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }

    private func getBalance(complete: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let multiTask = DispatchGroup()
            
            var errorOccurred = false
            
            for (index, wallet) in self.wallets.enumerated() {
                multiTask.enter()
                
                let request = EthGetBalance(address: wallet.address, quantity: "latest")
                
                let batch = self.batchFactory.create(request)
                let httpRequest = EthServiceRequest(batch: batch)
                
                Session.send(httpRequest, callbackQueue: nil) { (result) in
                    switch result {
                    case .success(let result):
                        self.wallets[index].balance = result
                        
                        multiTask.leave()
                    case .failure(let error):
                        debugPrint(error)
                        errorOccurred = true
                        multiTask.leave()
                    }
                }
                
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

