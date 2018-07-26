//
//  AddressesViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 25/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import ChameleonFramework

class AddressesViewController: UIViewController {
    
    var socail: SocialUser?
    
    let segmentedViewController = SJSegmentedViewController()
    var selectedSegment: SJSegmentTab?
    var sjdelegate: SJSegmentedViewControllerDelegate?
    
    // init pageview member
    lazy var savedTab: AddressSavedViewController? = {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let savedTab = main.instantiateViewController(withIdentifier: "AddressSavedViewController") as! AddressSavedViewController
        savedTab.socialUser = self.socail
        
        savedTab.title = "Saved"
        
        return savedTab
    }()
    
    lazy var popularTab: AddressPopularViewController? = {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let popularTab = main.instantiateViewController(withIdentifier: "AddressPopularViewController") as! AddressPopularViewController
        popularTab.title = "Popular"
        
        return popularTab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.title = "Addresses"
        // Do any additional setup after loading the view.
        self.setupSJSEgment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupSJSEgment() {
        segmentedViewController.segmentControllers = [savedTab!, popularTab!]
        
        segmentedViewController.segmentedScrollViewColor = .white
        
        segmentedViewController.segmentBackgroundColor = FlatWhite()
        
        segmentedViewController.segmentTitleColor = FlatNavyBlue()
        
        segmentedViewController.headerViewController = nil
        
        //Set height for headerview.
//        segmentedViewController.headerViewHeight = 100
        
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
    

}

extension AddressesViewController: SJSegmentedViewControllerDelegate {
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
