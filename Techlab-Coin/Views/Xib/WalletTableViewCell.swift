//
//  WalletTableViewCell.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/6/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    @IBOutlet weak var status: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(wallet: Wallet?) {
        if let wallet = wallet {
            self.address.text = wallet.address
            self.address.textColor = .red
            self.address.adjustsFontSizeToFitWidth = true
            
            let hexWithout0x = wallet.balance!.replacingOccurrences(of: "0x", with: "", options: .literal, range: nil)
            if let toUInt = UInt64(hexWithout0x, radix: 16) {
                self.balance.text = "\(toUInt)"
            } else {
                self.balance.text = wallet.balance!
            }
            
            self.balance.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBAction func lock(_ sender: UIButton) {
        
    }
}
