//
//  SignInViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 14/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import ChameleonFramework
import Unbox

class SignInViewController: UIViewController {
    
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var namePrLabel: UILabel!
    
    var socialAccount: SocialUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FlatWhite()
        
        self.gmailButton.backgroundColor = FlatRed()
        self.gmailButton.layer.cornerRadius = 3.0
        self.gmailButton.setTitleColor(FlatWhite(), for: .normal)
        
        self.facebookButton.backgroundColor = FlatBlue()
        self.facebookButton.layer.cornerRadius = 3.0
        self.facebookButton.setTitleColor(FlatWhite(), for: .normal)
        
        self.twitterButton.backgroundColor = FlatSkyBlue()
        self.twitterButton.layer.cornerRadius = 3.0
        self.twitterButton.setTitleColor(FlatWhite(), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginByGmail(_ sender: UIButton) {
        GmailClass.sharedInstance().loginWithGmail(viewController: self, successHandler: { (response) in
            self.socialAccount = GmailClass.sharedInstance().gmailUser
            
            self.transitionToHome()
        }, failHandler: { (failResponse) in
            debugPrint("Gmail error !")
        })
    }
    
    @IBAction func loginByFacebook(_ sender: UIButton) {
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (response) in
            guard let fbdata = FacebookClass.sharedInstance().fbData else {return}
            self.socialAccount = SocialUser(name: fbdata.name, email: fbdata.email, cover_url_string: fbdata.profilepic!.absoluteString, type: .facebook)
            
            self.transitionToHome()
        }) { (fail) in
            
        }
    }
    
    @IBAction func loginByTwitter(_ sender: UIButton) {
        TwitterClass.sharedInstance().loginWithTwitter(viewController: self, successHandler: { (response) in
            debugPrint("Twitter response : \(response)")
            TwitterClass.sharedInstance().getAccountInfo(userID: "", _data: { (data) in
                guard let dt = data else { return }
                
                let twdata: TwitterData = try! unbox(data: dt)
                
                self.socialAccount = SocialUser(name: twdata.name, email: twdata.email, cover_url_string: twdata.profile_image_url_https_string!.absoluteString, type: .twitter)
                
                self.transitionToHome()
            })
        }, failHandler: { (failResponse) in
            debugPrint("Twitter error !")
        })
    }
    
    func transitionToHome() {
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
//        let v1 = main.instantiateViewController(withIdentifier: "WalletsViewController") as! WalletsViewController
//        let v2 = main.instantiateViewController(withIdentifier: "PriceHistoryViewController") as! PriceHistoryViewController
        
        let v1 = main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        v1.socialUser = self.socialAccount
        
        v1.tabBarItem = ESTabBarItem.init(title: "Wallet", image: UIImage(named: "wallet"), selectedImage: UIImage(named: "wallet"))
//        v2.tabBarItem = ESTabBarItem.init(title: "History", image: UIImage(named: "history"), selectedImage: UIImage(named: "history"))
        let n1 = NavigationController.init(rootViewController: v1)
//        let n2 = NavigationController.init(rootViewController: v2)
        
//        v1.title = "Wallet"
//        v2.title = "History"
        
        tabBarController.viewControllers = [n1]
        
        tabBarController.switchRootViewController(animated: true, completion: nil)
        
    }
}
