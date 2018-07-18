//
//  AccountDetailViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/13/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController {
    
    var accountName: String?
    
    var wallet: Wallet?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = accountName ?? "Account"
        // Do any additional setup after loading the view.
        
        prepareInfomationWallet()
    }
    
    private func prepareInfomationWallet() {
        guard let wallet = self.wallet else {
            return
        }
        
        self.addressLabel.text = wallet.address
        
        let hexWithout0x = wallet.balance!.replacingOccurrences(of: "0x", with: "", options: .literal, range: nil)
        
        if let toUInt = UInt64(hexWithout0x, radix: 16) {
            self.balanceLabel.text = "\(toUInt)"
        } else {
            self.balanceLabel.text = wallet.balance!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transitionSendVC(_ sender: UIButton) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "SendViewController") as? SendViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
