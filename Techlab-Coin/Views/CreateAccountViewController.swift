//
//  CreateAccountViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var socialUser: SocialUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.uiCreateButton()
    }
    
    private func uiCreateButton() {
        self.createButton.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(_ sender: Any) {
        guard let _ = self.socialUser else {
            return
        }
        
        self._validate()
        
        if self.validate() {
            let target = MyApi.newAccount(passwd: self.passwordTextfield.text!, name: self.nameTextfield.text!, email: self.socialUser!.email, type: self.socialUser!.type.rawValue)
            
//            let target = MyApi.accounts
            debugPrint(target)
            MyApiAdap.request(target: target, success: { (response) in
                print(response)
            }, error: { (error) in
                print(error)
            }) { (fail) in
                print(fail)
            }
        }
    }
    
    private func validate() -> Bool {
        return self.nameErrorLabel.isHidden && self.passwordErrorLabel.isHidden
    }
    
    private func _validate() {
        if self.passwordTextfield.text! == "" {
            self.passwordErrorLabel.isHidden = false
        } else {
            self.passwordErrorLabel.isHidden = true
        }
        
        if self.nameTextfield.text!.isEmpty {
            self.nameErrorLabel.isHidden = false
        } else {
            self.nameErrorLabel.isHidden = true
        }
    }

}
