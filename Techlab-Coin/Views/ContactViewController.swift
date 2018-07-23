//
//  ContactViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/23/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import WebKit

class ContactViewController: UIViewController, WKNavigationDelegate {
    
    var isContact: Bool = true
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlString = self.isContact ? "https://www.tmh-techlab.vn/contact" : "http://www.tribalmedia.co.jp/en/about/"
        
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
        let leftNav = UIBarButtonItem(image: #imageLiteral(resourceName: "icn_back"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(pop))
        self.navigationItem.leftBarButtonItem = leftNav
    }
    
    @objc func pop() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
