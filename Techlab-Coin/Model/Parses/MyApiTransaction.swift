//
//  MyApiTransaction.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiTransaction {
    let blockHash: String
    let blockNumber: Int
    let hash: String
    let gas: Int
    let gasPrice: String
    let to: String
    let from: String
    let value: String
    let transactionIndex: Int
    let nonce: Int
}

extension MyApiTransaction: Unboxable {
    init(unboxer: Unboxer) throws {
        self.blockHash = try unboxer.unbox(keyPath: "transaction.blockHash")
        self.blockNumber = try unboxer.unbox(keyPath: "transaction.blockNumber")
        self.gas = try unboxer.unbox(keyPath: "transaction.gas")
        self.gasPrice = try unboxer.unbox(keyPath: "transaction.gasPrice")
        self.value = try unboxer.unbox(keyPath: "transaction.value")
        self.to = try unboxer.unbox(keyPath: "transaction.to")
        self.from = try unboxer.unbox(keyPath: "transaction.from")
        self.hash = try unboxer.unbox(keyPath: "transaction.hash")
        self.nonce = try unboxer.unbox(keyPath: "transaction.nonce")
        self.transactionIndex = try unboxer.unbox(keyPath: "transaction.transactionIndex")
    }
}

//
//{
//    "transaction": {
//        "blockHash": "0x721d080532b702c6b53384143a97a9d683f1e945e7251bcad64e796b643bc320",
//        "blockNumber": 4997,
//        "from": "0x88dda2D23A7cFC22a7fd603bc82Dd739bf66bA92",
//        "gas": 90000,
//        "gasPrice": "18000000000",
//        "hash": "0x9632a2526109120ed41868e947109be5b766b6c2e43efbe24b413bd301831937",
//        "input": "0x",
//        "nonce": 16,
//        "to": "0x5700fA0f3Cabf3FFF8d4826DDE8F71526Ed1B288",
//        "transactionIndex": 0,
//        "value": "100000000000",
//        "v": "0x4d",
//        "r": "0x622a59505319021b7d966b823ccd72df838a5446cc229092172a1588f40fca82",
//        "s": "0xa1251b30891594e2323c8ba09c47acefa162f7c2961dc9ec8f861e3769c38a2"
//    }
//}
