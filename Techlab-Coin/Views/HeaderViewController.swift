//
//  HeaderViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import GoogleSignIn
import ChameleonFramework

class HeaderViewController: UIViewController {

    @IBOutlet weak var totalAccountLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var socialUser: SocialUser?
    
    var wallets: [Wallet] = [] {
        didSet {
            self.totalAccountLabel.text = String(describing: self.wallets.count)
            let totalCost = self.wallets.compactMap({ Int($0.balance ?? "0") }).reduce(0, {x, y in x + y})
            self.totalCostLabel.text = String(describing: totalCost)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }

    func setupUI() {
        self.view.backgroundColor = FlatNavyBlue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func create(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController {
            vc.socialUser = self.socialUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func logout(_ sender: Any) {
        guard let socialU = self.socialUser else {
            return
        }
        
        switch socialU.type {
        case .facebook:
            FacebookClass.sharedInstance().logoutFromFacebook()
        case .twitter:
            TwitterClass.sharedInstance().logoutFromTwitter()
        default: // gmail
            GIDSignIn.sharedInstance().signOut()
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = main.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            vc.switchRootViewController(animated: true, completion: nil)
        }
    }
}
