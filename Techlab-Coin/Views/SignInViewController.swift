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
    
    @IBAction func loginByGmail(_ sender: UIButton) {
        
        self.gmailButton.loadingIndicator(true)
        
        GmailClass.sharedInstance().loginWithGmail(viewController: self, successHandler: { (response) in
            self.socialAccount = GmailClass.sharedInstance().gmailUser
            self.gmailButton.loadingIndicator(false)
            self.transitionToHome()
        }, failHandler: { (failResponse) in
            self.gmailButton.loadingIndicator(false)
            debugPrint("Gmail error !")
        })
    }
    
    @IBAction func loginByFacebook(_ sender: UIButton) {
        self.facebookButton.loadingIndicator(true)
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (response) in
            guard let fbdata = FacebookClass.sharedInstance().fbData else {return}
            self.socialAccount = SocialUser(name: fbdata.name, email: fbdata.email, cover_url_string: fbdata.profilepic!.absoluteString, type: .facebook)
            self.facebookButton.loadingIndicator(false)
            self.transitionToHome()
        }) { (fail) in
            self.facebookButton.loadingIndicator(false)
        }
    }
    
    @IBAction func loginByTwitter(_ sender: UIButton) {
        self.twitterButton.loadingIndicator(true)
        TwitterClass.sharedInstance().loginWithTwitter(viewController: self, successHandler: { (response) in
            debugPrint("Twitter response : \(response)")
            TwitterClass.sharedInstance().getAccountInfo(userID: "", _data: { (data) in
                guard let dt = data else { return }
                
                let twdata: TwitterData = try! unbox(data: dt)
                
                self.socialAccount = SocialUser(name: twdata.name, email: twdata.email, cover_url_string: twdata.profile_image_url_https_string!.absoluteString, type: .twitter)
                self.twitterButton.loadingIndicator(false)
                self.transitionToHome()
            })
        }, failHandler: { (failResponse) in
            self.twitterButton.loadingIndicator(false)
            debugPrint("Twitter error !")
        })
    }
    
    func transitionToHome() {
        let tabBarController = ESTabBarController()

        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
            tabBar.isTranslucent = true
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let v1 = main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        v1.socialUser = self.socialAccount
        
        v1.tabBarItem = ESTabBarItem.init(title: "Home", image: UIImage(named: "icn_home"), selectedImage: UIImage(named: "icn_home"))
        
        let n1 = NavigationController.init(rootViewController: v1)

        tabBarController.viewControllers = [n1]

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
