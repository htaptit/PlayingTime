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

class SendViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var huongdanLabel: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var targetAddressTextField: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var transactionCost: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var errorValue: UILabel!
    @IBOutlet weak var errorTargetAdd: UILabel!
    var wallet: Wallet?
    
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
        
        // Do any additional setup after loading the view.
        self.referenceWallet()
        self.sendButtonDesign()
        
        self.huongdanLabel.text = "- Your balance number is 0 and you can not send it. \n- You need to enter a smaller amount than you have. \n- You need to enter the address of the receiver (QRCode can be used)."
        self.huongdanLabel.numberOfLines = 0
    }
    
    private func sendButtonDesign() {
        self.sendButton.layer.cornerRadius = 10.0
    }
    
    private func referenceWallet() {
        guard let wallet = self.wallet else {
            return
        }
        
        self.address.text = wallet.name
        self.balance.text = wallet.balance ?? String(describing: 0)
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
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func send(_ sender: UIButton) {
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
        let value: String! = self.amount.text!
        
        let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 60,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter your password")
        
        _ = alert.addButton("Send") {
            let api = MyApi.sendTransaction(from: from, to: to, value: value, passwd: txt.text!)
            MyApiAdap.request(target: api, success: { (success) in
                do {
                    let data: MyApiSendTransactionResult = try unbox(data: success.data)
                    
                    if !data.unlock {
                        self.showAlertError()
                    }
                } catch {
                    debugPrint("Error !")
                }
                
            }, error: { (error) in
                debugPrint(error)
            }) { (fail) in
                debugPrint(fail)
            }
        }
        _  = alert.showCustom("Please enter your password", subTitle: "--------", color: UIColor(hex: "#16A2A4", alpha: 1.0), icon: #imageLiteral(resourceName: "lock"))
    }
    
    private func showAlertError() {
        SCLAlertView().showError("Authentication error.", subTitle: "Password not match !")
    }
    
    private func validate() -> Bool {
        return !self.amount.text!.isEmpty && !self.targetAddressTextField.text!.isEmpty
    }
}
