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
            self.name.text = wallet.name
            self.address.text = wallet.address
            self.address.textColor = .red
            self.address.adjustsFontSizeToFitWidth = true
            
            let balanceGWei = Int(wallet.balance ?? "0")! / Constants.Wei / Constants.GWei
            
            self.balance.text = "= " + String(describing: balanceGWei)
            
            self.balance.adjustsFontSizeToFitWidth = true
            
            self.createdAt.text = UnboxDateFormater.date(format: "eee MMM dd . hh").string(from: wallet.datetime) + "h"
        }
    }
    
    @IBAction func lock(_ sender: UIButton) {
        
    }
}
