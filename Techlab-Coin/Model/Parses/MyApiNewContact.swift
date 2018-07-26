//
//  MyApiNewContact.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiNewContact {
    let saved: Bool
}

extension MyApiNewContact: Unboxable {
    init(unboxer: Unboxer) throws {
        self.saved = try unboxer.unbox(keyPath: "saved")
    }
}
