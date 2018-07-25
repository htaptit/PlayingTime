//
//  HistoryTableViewCell.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var value: UILabel!
    
    var history: MyApiHistory? {
        didSet {
            self.prepareInfomation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func prepareInfomation() {
        guard let his = self.history else {
            return
        }
        
        self.name.text = his.name
        
        self.created_at.text = String(describing: UnboxDateFormater.date(format: "eee MMM dd . HH'h':mm'm'").string(from: his.created_at))
        
        self.to.text = his.to_address
        self.value.text = his.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
