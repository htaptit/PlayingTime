//
//  NavigationController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 13/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import ChameleonFramework

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: 0.0), for: .default)
        
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = FlatNavyBlue()
        #if swift(>=4.0)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)]
        #elseif swift(>=3.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)];
        #endif
        self.navigationBar.tintColor = UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.navigationItem.title = "Example"
    }
}
