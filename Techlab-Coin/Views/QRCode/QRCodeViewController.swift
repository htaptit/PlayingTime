//
//  QRCodeViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import QRCode
import ChameleonFramework

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
        shareButton.layer.cornerRadius = 5.0
        shareButton.backgroundColor = FlatRed()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Please select", message: "Share address or QRImage", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        actionSheet.addAction(cancelActionButton)
        
        let shareAddressActionButton = UIAlertAction(title: "Share Address", style: .default)
        { _ in
            self.shareAddress()
        }
        
        actionSheet.addAction(shareAddressActionButton)
        
        let shareQRImageCodeActionButton = UIAlertAction(title: "Share QR Image", style: .default)
        { _ in
            self.shareImageQR()
        }
        actionSheet.addAction(shareQRImageCodeActionButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func shareAddress() {
        
        // text to share
        guard let text = self.address else {
            return
        }
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    // share image
    private func shareImageQR() {
        if let image = self.qrimage.image {
            // set up activity view controller
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
}
