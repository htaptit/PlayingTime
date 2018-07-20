//
//  AccountDetailViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/13/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import Unbox
import ChameleonFramework

class AccountDetailViewController: UIViewController {
    
    var accountName: String?
    
    var wallet: Wallet?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var unlock: UIButton!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var share: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = accountName ?? "Account"
        // Do any additional setup after loading the view.
        
        prepareInfomationWallet()
        preparingBottomButton()
    }
    
    private func preparingBottomButton() {
        self.unlock.layer.cornerRadius = 5.0
        self.unlock.backgroundColor = FlatTeal()
        
        self.share.layer.cornerRadius = 5.0
        self.share.backgroundColor = FlatRed()
        
        self.send.layer.cornerRadius = 5.0
        self.send.backgroundColor = FlatNavyBlue()
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
        
        self.createdAtLabel.text = UnboxDateFormater.date(format: "eee MMM dd . hh").string(from: wallet.datetime) + " (hour)"
        
        self.getTransactionCount(address: wallet.address)
    }
    
    
    private func getTransactionCount(address: String) {
        let target = MyApi.getTransactionCount(addr: address)
        
        MyApiAdap.request(target: target, success: { (success) in
            do {
                let transactionCount: MyApiTransactionCount = try unbox(data: success.data)
                self.transactionLabel.text = String(describing: transactionCount.transactionCount)
            } catch {
                
            }
            
            self.view.setNeedsDisplay()
        }, error: { (error) in
            debugPrint(error)
        }) { (fail) in
            debugPrint(fail)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transitionSendVC(_ sender: UIButton) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "SendViewController") as? SendViewController {
            vc.wallet = self.wallet
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func unlock(_ sender: Any) {
    }
    @IBAction func share(_ sender: Any) {
    }
}
