//
//  MyApiTransactionCount.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/20/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiTransactionCount {
    let transactionCount: Int
}

extension MyApiTransactionCount: Unboxable {
    init(unboxer: Unboxer) throws {
        self.transactionCount = try unboxer.unbox(keyPath: "transactionCount")
    }
}
