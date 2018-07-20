//
//  MyApiSendTransactionResult.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/20/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiSendTransactionResult {
    let unlock: Bool
    let infoTransaction: MyApiInfoTransactionBeforeSend?
}

extension MyApiSendTransactionResult: Unboxable {
    init(unboxer: Unboxer) throws {
        self.unlock = try unboxer.unbox(keyPath: "unlock")
        self.infoTransaction = try? unboxer.unbox(keyPath: "infoTransaction")
    }
}

