//
//  CreateAccountViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import TweeTextField
import ChameleonFramework
import Unbox
import NotificationBannerSwift
import SCLAlertView

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var nameTextfield: TweeBorderedTextField!
    @IBOutlet weak var passwordTextfield: TweeActiveTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var icnTypeSocial: UIImageView!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPassword: UILabel!
    
    @IBOutlet weak var formLabel: UILabel!
    var socialUser: SocialUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let user = self.socialUser {
            
            self.icnTypeSocial.layer.cornerRadius = 10.0
            
            self.email.text = user.email
            switch user.type {
            case .gmail:
                self.icnTypeSocial.image = #imageLiteral(resourceName: "icn_gmail")
            case .facebook:
                self.icnTypeSocial.image = #imageLiteral(resourceName: "icn_facebook")
            default:
                self.icnTypeSocial.image = #imageLiteral(resourceName: "icn_twitter")
            }
        }
        
        // Do any additional setup after loading the view.
        self.uiCreateButton()
    }
    
    private func uiCreateButton() {
        formLabel.textColor = FlatNavyBlue()
        self.createButton.layer.cornerRadius = 10.0
        self.createButton.backgroundColor = FlatNavyBlue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func create(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let _ = self.socialUser else {
            return
        }
        
        self._validate()
        
        if self.validate() {
            self.showIndicator(message: "")
            
            let target = MyApi.newAccount(passwd: self.passwordTextfield.text!, name: self.nameTextfield.text!, email: self.socialUser!.email, type: self.socialUser!.type.rawValue)
            
            MyApiAdap.request(target: target, success: { (response) in
                self.hideIndicator()
                do {
                    let newAccount: MyApiNewAccount = try unbox(data: response.data)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
                    
                    self.showAlert(address: newAccount.account)
                } catch {
                    
                }
            }, error: { (error) in
                print(error)
                self.hideIndicator()
            }) { (fail) in
                print(fail)
                self.hideIndicator()
            }
        }
    }
    
    private func showAlert(address: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Close") {
            self.navigationController?.popViewController(animated: true)
        }
        
        alertView.showSuccess("Created account !", subTitle: address)
    }
    
    @IBAction func confirmPasswordChange(_ sender: TweeActiveTextField) {
        if sender.text! != self.passwordTextfield.text! {
            self.confirmPassword.isHidden = false
        } else {
            self.confirmPassword.isHidden = true
        }
    }
    
    private func validate() -> Bool {
        return self.nameErrorLabel.isHidden && self.passwordErrorLabel.isHidden && self.confirmPassword.isHidden
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
