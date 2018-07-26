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
import NotificationBannerSwift
import TweeTextField
import NVActivityIndicatorView

class AccountDetailViewController: UIViewController {
    
    var accountName: String?
    
    var wallet: Wallet?
    
    var social: SocialUser?

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var passwordTextfield: TweeActiveTextField!
    
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
        
        self.name.text = wallet.name
        self.addressLabel.text = wallet.address
        
        if let balance = wallet.balance, let n = NumberFormatter().number(from: balance.replacingOccurrences(of: ".", with: ",")) as? CGFloat {
            self.balanceLabel.text = String(describing: n)
            
            self.usdLabel.text = String(describing: n / Constants.TCL)
        }
        
        self.createdAtLabel.text = UnboxDateFormater.date(format: "eee MMM dd . HH").string(from: wallet.datetime) + "h"
        
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
    @IBAction func copyAddressToClipboard(_ sender: Any) {
        UIPasteboard.general.string = self.wallet?.address
        let banner = StatusBarNotificationBanner(title: "Copied to clipboard !", style: .success, colors: nil)
        banner.autoDismiss = true
        banner.show()
    }
    
    @IBAction func transitionSendVC(_ sender: UIButton) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "SendViewController") as? SendViewController {
            vc.wallet = self.wallet
            vc.social = self.social
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func unlock(_ sender: Any) {
        self.view.endEditing(true)
        guard let wallet = self.wallet, let passwrd = self.passwordTextfield.text else {
            return
        }
        
        self.showIndicator(message: "")
        
        let target = MyApi.unlockAccount(address: wallet.address, passwd: passwrd)
        
        MyApiAdap.request(target: target, success: { (success) in
            do {
                let unlocked: MyApiUnlockAccount = try unbox(data: success.data)
                
                self.hideIndicator()
                
                if unlocked.unlock {
                    let banner = NotificationBanner(title: "Unlock success", subtitle: nil, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                    banner.autoDismiss = true
                    banner.show(bannerPosition: .bottom)
                } else {
                    let banner = NotificationBanner(title: "Unlock fail", subtitle: nil, leftView: nil, rightView: nil, style: BannerStyle.warning, colors: nil)
                    banner.autoDismiss = true
                    banner.show(bannerPosition: .bottom)
                }
            } catch {
                self.hideIndicator()
            }
        }, error: { (error) in
            debugPrint(error)
            self.hideIndicator()
        }) { (fail) in
            debugPrint(fail)
            self.hideIndicator()
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Please select", message: "Share address", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        actionSheet.addAction(cancelActionButton)
        
        let shareAddressActionButton = UIAlertAction(title: "Share Address", style: .default)
        { _ in
            self.shareAddress()
        }
        
        actionSheet.addAction(shareAddressActionButton)
 
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func shareAddress() {
        
        // text to share
        guard let text = self.wallet?.address else {
            return
        }
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }    
}
