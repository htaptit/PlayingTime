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
            
            if let balance = wallet.balance, let n = NumberFormatter().number(from: balance.replacingOccurrences(of: ".", with: ",")) as? CGFloat {
                self.balance.text = "= " + String(describing: n)
            }
            
            self.balance.adjustsFontSizeToFitWidth = true
            self.createdAt.text = UnboxDateFormater.date(format: "eee MMM dd . HH'h':mm'm'").string(from: wallet.datetime)
        }
    }
    
    @IBAction func lock(_ sender: UIButton) {
        
    }
}
