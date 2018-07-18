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

class HomeViewController: UIViewController {
    
    var socialUser: SocialUser?
    
    @IBOutlet var leftBarUIView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
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
        setNeedsStatusBarAppearanceUpdate()
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
        
        self.headerViewController?.socialUser = self.socialUser
        
        segmentedViewController.headerViewController = self.headerViewController
        
        //Set height for headerview.
        segmentedViewController.headerViewHeight = 100
        
        //Set height for segmentview.
        segmentedViewController.segmentViewHeight = 39.0
        
//        //Set color for selected segment.
//        segmentedViewController.selectedSegmentViewColor = UIColor(hex: AppColor.accentColor, alpha: 1.0)
//
//        //Set color for segment title.
//        segmentedViewController.segmentTitleColor = UIColor(hex: AppColor.primaryColor, alpha: 1.0)
//
//        //Set background color for segmentview.
//        segmentedViewController.segmentBackgroundColor = UIColor(hex: AppColor.dividerColor, alpha: 1.0)
        
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "#16A2A4", alpha: 1.0)
    }
    
    @objc func goToWalletsViewController() {
        let main  = UIStoryboard(name: "Main", bundle: nil)
        if let vc = main.instantiateViewController(withIdentifier: "WalletsViewController") as? WalletsViewController {
            vc.isCreateQRCode = true
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
            self.selectedSegment?.titleColor(UIColor(hex: "#16A2A4", alpha: 1.0))
        }
        if self.segmentedViewController.segments.count > 0 {
            self.selectedSegment = self.segmentedViewController.segments[index]
            self.selectedSegment?.titleColor(UIColor.red)
        }
    }
}
