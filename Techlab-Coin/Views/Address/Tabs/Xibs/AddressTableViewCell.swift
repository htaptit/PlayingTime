//
//  AddressTableViewCell.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var type: UIImageView!
    
    var tuples: (name: String, email: String, type: Int)? {
        didSet {
            guard let data = self.tuples else {
                return
            }
            
            self.name.text = data.name
            self.email.text = data.email
            
            switch data.type {
            case TypeSocial.facebook.rawValue:
                type.image = #imageLiteral(resourceName: "icn_facebook")
            case TypeSocial.gmail.rawValue:
                type.image = #imageLiteral(resourceName: "icn_gmail")
            default:
                type.image = #imageLiteral(resourceName: "icn_twitter")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        type.layer.cornerRadius = 35.0 / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
