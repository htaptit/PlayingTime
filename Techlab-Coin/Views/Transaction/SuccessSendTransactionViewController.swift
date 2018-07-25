//
//  SuccessSendTransactionViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import ChameleonFramework

class SuccessSendTransactionViewController: UIViewController {

    var result: MyApiSendTransactionResult?
    
    @IBOutlet weak var showDetail: UIButton!
    @IBOutlet weak var success: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var close: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlatNavyBlue()
        
        self.showDetail.layer.cornerRadius = 10.0
        self.showDetail.backgroundColor = FlatLime()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        
    }
}
