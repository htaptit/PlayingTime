//
//  SendViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/13/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import SCLAlertView
import Unbox
import ChameleonFramework
import TweeTextField
import NotificationBannerSwift

class SendViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var huongdanLabel: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var targetAddressTextField: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var targetName: UILabel!
    
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var saveToContactButton: UIButton!
    
    @IBOutlet weak var errorValue: UILabel!
    @IBOutlet weak var errorTargetAdd: UILabel!
    var wallet: Wallet?
    
    var social: SocialUser?
    
    lazy var reader: QRCodeReader = QRCodeReader()
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Send Form"
        
        self.sendButtonDesign()
        // Do any additional setup after loading the view.
        self.referenceWallet()
        
        self.huongdanLabel.text = "- Your balance number is 0 and you can not send it. \n- You need to enter a smaller amount than you have. \n- You need to enter the address of the receiver (QRCode can be used)."
        self.huongdanLabel.numberOfLines = 0
        
        self.saveToContactButton.backgroundColor = FlatGray()
        self.saveToContactButton.isEnabled = false
    }
    
    private func sendButtonDesign() {
        self.targetView.layer.cornerRadius = 25.0
        self.sendButton.layer.cornerRadius = 10.0
        self.sendButton.backgroundColor = FlatRed()
        
        self.saveToContactButton.layer.cornerRadius = 25.0
        self.saveToContactButton.backgroundColor = FlatGreen()
    }
    
    private func referenceWallet() {
        guard let wallet = self.wallet else {
            return
        }

        self.address.text = wallet.name
        
        if let balance = wallet.balance, let n = NumberFormatter().number(from: balance.replacingOccurrences(of: ".", with: ",")) as? CGFloat {
            self.balance.text = String(describing: n)
            
            if n == 0.0 {
                self.sendButton.backgroundColor = FlatGray()
                self.sendButton.isEnabled = false
            } else {
                self.sendButton.backgroundColor = FlatRed()
                self.sendButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var scanAddressResult: String?
    
    @IBAction func saveToContact(_ sender: UIButton) {
        guard let targetAdd = self.targetAddressTextField.text else {
            
            return
        }
        
        let api = MyApi.newContacts(email: self.social!.email, type: self.social!.type.rawValue, address: targetAdd)
        
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let data: MyApiNewContact = try unbox(data: success.data)
                
                if data.saved {
                    print("Saved")
                    let banner = NotificationBanner(title: "Saved", subtitle: "You can view in your contact", leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                    banner.autoDismiss = true
                    banner.show(bannerPosition: .bottom)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("refreshContact"), object: nil)
                }
            } catch {
                
            }
        }, error: { (error) in
            print(error)
        }) { (fail) in
            print(fail)
        }
    }
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                self.targetAddressTextField.text = result.value
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        
        
        self.getNameByAdress(address: result.value)
        
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getNameByAdress(address: String) {
        let api = MyApi.getNameByAddress(address: address)
        
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let data: MyApiNameEmailByAdress = try unbox(data: success.data)
                
                self.targetName.text = data.name
                
                self.saveToContactButton.isEnabled = true
                self.saveToContactButton.backgroundColor = FlatGreen()
            } catch {
                
            }
        }, error: { (erorr) in
            print(erorr)
        }) { (fail) in
            print(fail)
        }
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func send(_ sender: UIButton) {
        self.validateAmount()
        self.validateAddress()
        preparingDataBeforeSend()
    }
    
    private func preparingDataBeforeSend() {
        if self.validate() {
            showEdit()
        } else {
            
        }
    }
    
    func showEdit() {
        self.view.endEditing(true)
        
        guard let wallet = self.wallet else {
            return
        }
        
        let from: String = wallet.address
        let to: String = self.targetAddressTextField.text!
        let value: String = self.amount.text!
        
        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 60,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter your password")
        txt.isSecureTextEntry = true
        
        _ = alert.addButton("Send and wait until done") {
            self.sendTransaction(from: from, to: to, pasword: txt.text!, value: value, isWait: true)
        }
        
        _ = alert.addButton("Send and wait for notification") {
            self.sendTransaction(from: from, to: to, pasword: txt.text!, value: value)
        }
        
        
        
        
        _  = alert.showCustom("Please enter your password", subTitle: "--------", color: UIColor(hex: "#16A2A4", alpha: 1.0), icon: #imageLiteral(resourceName: "lock"))
    }
    
    private func sendTransaction(from: String, to: String, pasword: String, value: String, isWait: Bool = false) {
        if isWait {
            self.showIndicator(message: "Sending ...")
        }
        
        let api = MyApi.sendTransaction(from: from, to: to, value: value, passwd: pasword)
        
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let data: MyApiSendTransactionResult = try unbox(data: success.data)
                
                if !data.unlock {
                    self.showAlertError()
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("refreshData"), object: nil)
                
                if isWait {
                    let main = UIStoryboard.init(name: "Main", bundle: nil)
                    if let vc = main.instantiateViewController(withIdentifier: "SuccessSendTransactionViewController") as? SuccessSendTransactionViewController {
                        vc.result = data
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
            } catch {
                debugPrint("Error !")
            }
            
            self.hideIndicator()
            
        }, error: { (error) in
            self.hideIndicator()
            debugPrint(error)
        }) { (fail) in
            self.hideIndicator()
            debugPrint(fail)
        }
    }
    
    
    private func showAlertError() {
        SCLAlertView().showError("Authentication error.", subTitle: "Password not match !")
    }
    
    private func validate() -> Bool {
        return self.errorValue.isHidden && self.errorTargetAdd.isHidden
    }
    
    private func validateAddress() {
        self.showIndicator(message: "Validating address of target ...")
        
        let api = MyApi.checkIsAddress(addr: self.targetAddressTextField.text!)
        MyApiAdap.request(target: api, success: { (success) in
            do {
                let result: MyApiCheckIsAddress = try unbox(data: success.data)
                if result.isAddress {
                    self.errorTargetAdd.isHidden = true
                } else {
                    self.errorTargetAdd.isHidden = false
                    self.errorTargetAdd.text = "Address incorrect format"
                }
            } catch {
                
            }
            self.hideIndicator()
        }, error: { (error) in
            print(error)
            self.hideIndicator()
        }) { (fail) in
            print(fail)
            self.hideIndicator()
        }
    }
    
    private func validateAmount() {
        if let text = self.amount.text, text.isEmpty {
            self.errorValue.isHidden = false
            return
        }
        
        self.errorValue.isHidden = true
    }
    
    @IBAction func valueEditing(_ sender: TweeBorderedTextField) {
        guard let text = sender.text, let _ = NumberFormatter().number(from: text) else {
            self.errorValue.isHidden = false
            self.errorValue.text = "Must be a number"
            return
        }
        
        self.errorValue.isHidden = true
    }
    
    @IBAction func valueEndEditing(_ sender: TweeBorderedTextField) {
        guard let text = sender.text else {
            self.errorValue.isHidden = false
            self.errorValue.text = "Must not be empty"
            return
        }
        
        if text.isEmpty {
            self.errorValue.isHidden = false
            self.errorValue.text = "Must not be empty"
        } else {
            if let _ = NumberFormatter().number(from: text) {
                self.errorValue.isHidden = true
                self.errorValue.text = "Must be a number"
                return
            }
            
            self.errorValue.isHidden = false
        }
    }
    
    
    @IBAction func targetDidChange(_ sender: TweeBorderedTextField) {
    }
    
    @IBAction func targetDidEnd(_ sender: TweeBorderedTextField) {
    }
}
