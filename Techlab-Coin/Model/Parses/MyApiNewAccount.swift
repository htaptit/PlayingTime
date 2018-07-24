//
//  MyApiNewAccount.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/24/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiNewAccount {
    let account: String
}

extension MyApiNewAccount: Unboxable {
    init(unboxer: Unboxer) throws {
        self.account = try unboxer.unbox(keyPath: "account")
    }
}
