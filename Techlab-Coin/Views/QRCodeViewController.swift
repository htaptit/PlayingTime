//
//  QRCodeViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import QRCode

class QRCodeViewController: UIViewController {
    
    var address: String?
    
    @IBOutlet weak var qrimage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QRCode"
        
        // Do any additional setup after loading the view.
        self.encodeAddressToQRCode()
        self.uiShare()
    }
    
    
    private func encodeAddressToQRCode() {
        guard let address = self.address else {
            return
        }
        
        addressLabel.text = address
        addressLabel.adjustsFontSizeToFitWidth = true
        var qrCode = QRCode(address)
        qrCode?.size = CGSize(width: 200.0, height: 200.0)
        qrimage.image = qrCode?.image
    }
    
    private func uiShare() {
        shareButton.layer.cornerRadius = 10.0
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func share(_ sender: Any) {
        
    }
}
