//
//  MyApiUsers.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/19/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiUsers {
    let accounts: [MyApiUser]
}

extension MyApiUsers: Unboxable {
    init(unboxer: Unboxer) throws {
        self.accounts = try unboxer.unbox(keyPath: "accounts")
    }
}
