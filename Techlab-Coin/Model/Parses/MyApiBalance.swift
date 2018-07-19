//
//  MyApiBalance.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/19/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiBalance {
    let balance: String
}

extension MyApiBalance: Unboxable {
    init(unboxer: Unboxer) throws {
        self.balance = try unboxer.unbox(keyPath: "balance")
    }
}
