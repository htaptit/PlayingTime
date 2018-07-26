//
//  TransactionDetailViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import ChameleonFramework
import Unbox

class TransactionDetailViewController: UIViewController {

    var transaction: MyApiTransaction?
    
    var baseInforTransaction: MyApiHistory?
    
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var addressFrom: UILabel!
    @IBOutlet weak var transactions: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var addressTo: UILabel!
    @IBOutlet weak var transactionTo: UILabel!
    @IBOutlet weak var emailTo: UILabel!
    @IBOutlet weak var blockHash: UILabel!
    @IBOutlet weak var blockNumber: UILabel!
    @IBOutlet weak var gas: UILabel!
    @IBOutlet weak var gasPrice: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var nounce: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exportButton.layer.cornerRadius = 10.0
        exportButton.backgroundColor = FlatSkyBlue()
        
        self.getTransaction() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getTransaction() {
        guard let base = self.baseInforTransaction else {
            return
        }
        
        let api = MyApi.getTransaction(hash: base.transaction_hash)
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let data: MyApiTransaction = try unbox(data: success.data)
                
                self.transaction = data
                
                self.applyInfomationTransaction()
            } catch {
                
            }
        }, error: { (error) in
            print(error)
        }) { (fail) in
            print(fail)
        }
    }
    
    private func applyInfomationTransaction () {
        guard let transaction = self.transaction, let baseT = self.baseInforTransaction else {
            return
        }
        
        self.from.text = baseT.name
        
        
        self.addressFrom.text = transaction.from
        self.addressTo.text = transaction.to
        self.to.text = baseT.to_address
        
        self.blockHash.text = transaction.blockHash
        self.blockNumber.text = String(describing: transaction.blockNumber)
        self.gas.text = String(describing: transaction.gas)
        self.gasPrice.text = transaction.gasPrice
        self.nounce.text = String(describing: transaction.nonce)
        
    }
    
    @IBAction func export(_ sender: UIButton) {
        
    }

}
