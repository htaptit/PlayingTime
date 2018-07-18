//
//  UIColor.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 128/255, green: 128/255, blue: 128/255, alpha: alpha)
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            let components = (
                R: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                G: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                B: CGFloat(rgbValue & 0x0000FF) / 255.0
            )
            self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
        }
    }
}
