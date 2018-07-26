//
//  UIViewController.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/17/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    func showIndicator(message: String) {
        let data = ActivityData(size: CGSize(width: 30, height: 30),
                                message: message,
                                messageFont: nil,
                                type: .lineScalePulseOut,
                                color: nil,
                                padding: nil,
                                displayTimeThreshold: nil,
                                minimumDisplayTime: 0,
                                backgroundColor: nil,
                                textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
    }
    
    func updateIndicator(message: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
    }
    
    func hideIndicator() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}

extension UIViewController {
    func switchRootViewController(animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow as? WallpaperWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = self
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = self
        }
    }
}
