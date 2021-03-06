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
import NVActivityIndicatorView

class SignInViewController: UIViewController {
    
    @IBOutlet weak var logobg: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    var socialAccount: SocialUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        logobg.backgroundColor = FlatNavyBlue().withAlphaComponent(0.5)
        logobg.layer.cornerRadius = 50.0
        logobg.image = #imageLiteral(resourceName: "logobacgroud")

        self.gmailButton.layer.cornerRadius = 5.0
        self.gmailButton.backgroundColor = FlatRed()
        
        self.facebookButton.layer.cornerRadius = 5.0
        self.facebookButton.backgroundColor = FlatBlue()
        
        self.twitterButton.layer.cornerRadius = 5.0
        self.twitterButton.backgroundColor = FlatSkyBlue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func lockAllButton(_ status: Bool) {
        self.gmailButton.loadingIndicator(status)
        self.facebookButton.loadingIndicator(status)
        self.twitterButton.loadingIndicator(status)
    }
    
    @IBAction func loginByGmail(_ sender: UIButton) {
        
        self.lockAllButton(true)
        
        GmailClass.sharedInstance().loginWithGmail(viewController: self, successHandler: { (response) in
            self.socialAccount = GmailClass.sharedInstance().gmailUser
            self.lockAllButton(false)
            self.transitionToHome()
        }, failHandler: { (failResponse) in
            self.lockAllButton(false)
            debugPrint("Gmail error !")
        })
    }
    
    @IBAction func loginByFacebook(_ sender: UIButton) {
        self.lockAllButton(true)
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (response) in
            guard let fbdata = FacebookClass.sharedInstance().fbData else {return}
            self.socialAccount = SocialUser(name: fbdata.name, email: fbdata.email, cover_url_string: fbdata.profilepic!.absoluteString, type: .facebook)
            self.lockAllButton(false)
            self.transitionToHome()
        }) { (fail) in
            self.lockAllButton(false)
        }
    }
    
    @IBAction func loginByTwitter(_ sender: UIButton) {
        self.lockAllButton(true)
        TwitterClass.sharedInstance().loginWithTwitter(viewController: self, successHandler: { (response) in
            debugPrint("Twitter response : \(response)")
            TwitterClass.sharedInstance().getAccountInfo(userID: "", _data: { (data) in
                guard let dt = data else { return }
                
                let twdata: TwitterData = try! unbox(data: dt)
                
                self.socialAccount = SocialUser(name: twdata.name, email: twdata.email, cover_url_string: twdata.profile_image_url_https_string!.absoluteString, type: .twitter)
                self.lockAllButton(false)
                self.transitionToHome()
            })
        }, failHandler: { (failResponse) in
            self.lockAllButton(false)
            debugPrint("Twitter error !")
        })
    }
    
    func transitionToHome() {
        let tabBarController = ESTabBarController()

        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
            tabBar.barTintColor = .white
            tabBar.tintColor = FlatNavyBlue()
            tabBar.isTranslucent = false
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let v1 = main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        v1.socialUser = self.socialAccount
        
        v1.tabBarItem = ESTabBarItem.init(title: "Home", image: UIImage(named: "icn_home"), selectedImage: UIImage(named: "icn_home_selecter"))
        
        let n1 = NavigationController.init(rootViewController: v1)

        let v2 = main.instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
        v2.socail = self.socialAccount
        
        v2.tabBarItem = ESTabBarItem.init(title: "Addresses", image: UIImage(named: "icn_address"), selectedImage: UIImage(named: "icn_address_selected"))
        
        let n2 = NavigationController.init(rootViewController: v2)
        
        tabBarController.viewControllers = [n1, n2]

        tabBarController.switchRootViewController(animated: true, completion: nil)
        
    }
    @IBAction func transitionContactUS(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        
        self.present(NavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @IBAction func transitionAbout(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        vc.isContact = false
        self.present(NavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
