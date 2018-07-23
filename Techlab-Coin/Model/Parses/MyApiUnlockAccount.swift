//
//  MyApiUnlockAccount.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/23/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiUnlockAccount {
    let unlock: Bool
}

extension MyApiUnlockAccount: Unboxable {
    init(unboxer: Unboxer) throws {
        self.unlock = try unboxer.unbox(keyPath: "unlock")
    }
}
