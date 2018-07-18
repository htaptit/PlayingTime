//
//  HeaderViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import GoogleSignIn

class HeaderViewController: UIViewController {

    @IBOutlet weak var totalAccountLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var socialUser: SocialUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    func setupUI() {
        self.createButton.layer.cornerRadius = 10.0
        self.createButton.layer.borderColor = UIColor.gray.cgColor
        self.createButton.layer.borderWidth = 0.2
        
        self.logoutButton.layer.cornerRadius = 10.0
        self.logoutButton.layer.borderColor = UIColor.gray.cgColor
        self.logoutButton.layer.borderWidth = 0.2
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
