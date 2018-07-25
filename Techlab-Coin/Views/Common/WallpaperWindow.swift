//
//  WallpaperWindow.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 21/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//
import UIKit

class WallpaperWindow: UIWindow {
    
    var wallpaper: UIImage? {
        didSet {
            // refresh if the image changed
            setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        //clear the background color of all table views, so we can see the background
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // draw the wallper if set, otherwise default behaviour
        if let wallpaper = wallpaper {
            wallpaper.draw(in: self.bounds);
        } else {
            super.draw(rect)
        }
    }
}
