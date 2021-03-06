//
//  HomeViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import SDWebImage
import SJSegmentedScrollView
import Unbox
import GoogleSignIn
import ChameleonFramework

class HomeViewController: UIViewController {
    
    var socialUser: SocialUser?
    
    @IBOutlet var leftBarUIView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    var wallets: [Wallet] = []
    
    var users: MyApiUsers?
    
    let segmentedViewController = SJSegmentedViewController()
    var selectedSegment: SJSegmentTab?
    var sjdelegate: SJSegmentedViewControllerDelegate?
    
    // init pageview member
    lazy var walletsTab: WalletsViewController? = {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let walletsTab = main.instantiateViewController(withIdentifier: "WalletsViewController") as! WalletsViewController
        walletsTab.title = "Wallets"
        
        return walletsTab
    }()
    
    lazy var historyTab: PriceHistoryViewController? = {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let historyTab = main.instantiateViewController(withIdentifier: "PriceHistoryViewController") as! PriceHistoryViewController
        historyTab.title = "History"
        
        return historyTab
    }()
    
    lazy var headerViewController: HeaderViewController? = {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let headerViewController = main.instantiateViewController(withIdentifier: "HeaderViewController") as! HeaderViewController
        return headerViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNavigationBar()
        
        self.setupSJSEgment()
        
        self.getAccounts()
        self.automaticallyAdjustsScrollViewInsets = true
        setNeedsStatusBarAppearanceUpdate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("refresh"), object: nil)
    }
    
    @objc func refresh() {
        self.wallets = []
        self.getAccounts()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSJSEgment() {
        segmentedViewController.segmentControllers = [walletsTab!, historyTab!]
        
        walletsTab?.social = self.socialUser
        
        self.headerViewController?.socialUser = self.socialUser
        
        segmentedViewController.segmentBackgroundColor = FlatWhite()
        
        segmentedViewController.segmentTitleColor = FlatNavyBlue()
        
        segmentedViewController.segmentedScrollViewColor = .white
        
        segmentedViewController.headerViewController = self.headerViewController
        
        //Set height for headerview.
        segmentedViewController.headerViewHeight = 100
        
        //Set height for segmentview.
        segmentedViewController.segmentViewHeight = 39.0
        
        //Set shadow for segmentview.
        segmentedViewController.segmentShadow = SJShadow(offset: .zero, color: .white, radius: 0, opacity: 0)
        
        //Set bounce for segmentview.
        segmentedViewController.segmentBounces = true
        
        //Set font for segmentview titles.
        segmentedViewController.segmentTitleFont = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold)
        
        //Set height for selected segmentview.
        segmentedViewController.selectedSegmentViewHeight = 3.0
        
        //Set height for headerview to visible after scrolling
        segmentedViewController.headerViewOffsetHeight = 0.0
        
        segmentedViewController.delegate = self
        
        addChildViewController(segmentedViewController)
        
        self.view.addSubview(segmentedViewController.view)
        
        var heightNav: CGFloat = 0.0
        if let height = self.navigationController?.navigationBar.frame.height {
            heightNav = height
        }

        let heightStatusBar = UIApplication.shared.statusBarFrame.height
        
        segmentedViewController.view.frame = CGRect(x: 0.0, y: heightNav + heightStatusBar, width: self.view.bounds.width, height: self.view.bounds.height - heightNav - heightStatusBar)
        
        segmentedViewController.didMove(toParentViewController: self)
    }
    
    
    private func setupNavigationBar() {
        
        guard let socialUser = self.socialUser else { return }

        self.name.text = socialUser.name
        self.email.text = socialUser.email
        
        self.image.layer.cornerRadius = 20
        self.image.clipsToBounds = true
        
        self.image.isUserInteractionEnabled = true
        let tabGuesture = UITapGestureRecognizer(target: self, action: #selector(logout))
        self.image.addGestureRecognizer(tabGuesture)
        
        switch socialUser.type {
        case .facebook:
            self.typeImage.image = #imageLiteral(resourceName: "facebook")
            self.image.sd_setImage(with: URL(string: socialUser.cover_url_string), completed: nil)
        case .twitter:
            self.typeImage.image = #imageLiteral(resourceName: "twitter")
            self.image.sd_setImage(with: URL(string: socialUser.cover_url_string), completed: nil)
        default:
            self.typeImage.image = #imageLiteral(resourceName: "gmail")
            self.image.sd_setImage(with: URL(string: socialUser.cover_url_string), completed: nil)
        }

        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.leftBarUIView)]
        
        let qrImage = UIImageView(image: #imageLiteral(resourceName: "qrcode"))
        qrImage.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        qrImage.contentMode = .scaleAspectFit
        qrImage.clipsToBounds = true
        
        qrImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToWalletsViewController))
        qrImage.addGestureRecognizer(tap)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: qrImage)]

        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    @objc func logout() {
        let actionSheet: UIAlertController = UIAlertController(title: "Want to sign out?", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        actionSheet.addAction(cancelActionButton)
        
        let logoutActionButton = UIAlertAction(title: "Sign out", style: .default)
        { _ in
            self.logoutAction()
        }
        
        actionSheet.addAction(logoutActionButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func logoutAction() {
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
    
    private func getAccounts() {
        guard let _ = self.socialUser else {
            return
        }
        
        self.showIndicator(message: "")
        
        let target = MyApi.accounts(email: self.socialUser!.email, type: self.socialUser!.type.rawValue)
        
        MyApiAdap.request(target: target, success: { (succes) in
            do {
                let data: MyApiUsers = try unbox(data: succes.data)
                
                self.users = data
                
                self.getBalance {
                    self.walletsTab?.wallets = self.wallets.reversed()
                    self.historyTab?.socialUser = self.socialUser
                    self.headerViewController?.wallets = self.wallets
                }
                
            } catch {
                
            }
            self.hideIndicator()
        }, error: { (error) in
            debugPrint(error)
            self.hideIndicator()
        }) { (fail) in
            debugPrint(fail)
            self.hideIndicator()
        }
        
    }
    
    private func getBalance(complete: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let multiTask = DispatchGroup()
            
            var errorOccurred = false
            
            for (index, user) in self.users!.accounts.enumerated() {
                multiTask.enter()
                
                MyApiAdap.request(target: MyApi.getBalance(address: user.address), success: { (succes) in
                    do {
                        let balance: MyApiBalance = try unbox(data: succes.data)
                        
                        self.wallets.append(Wallet(name: self.users!.accounts[index].name, datetime: self.users!.accounts[index].datetime, address: self.users!.accounts[index].address, balance: balance.balance))
                    } catch {
                        
                    }
                    
                    multiTask.leave()
                }, error: { (error) in
                    
                    errorOccurred = true
                    multiTask.leave()
                }, failure: { (fail) in
                    
                    errorOccurred = true
                    multiTask.leave()
                })
                
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
    
    @objc func goToWalletsViewController() {
        let main  = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "WalletsViewController") as? WalletsViewController {
            vc.isCreateQRCode = true
            vc.wallets = self.wallets
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

}

extension HomeViewController: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if self.selectedSegment != nil {
            self.selectedSegment?.titleColor(FlatNavyBlue())
        }
        if self.segmentedViewController.segments.count > 0 {
            self.selectedSegment = self.segmentedViewController.segments[index]
            self.selectedSegment?.titleColor(UIColor.red)
        }
    }
}
