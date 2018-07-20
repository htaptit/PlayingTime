//
//  MyApiInfoTransactionBeforeSend.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/20/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiInfoTransactionBeforeSend {
    let blockHash: String
    let blockNumber: String
    let contractAddress: String?
    let gasUsed: Int
    let root: String
    let to: String
    let from: String
    let transactionHash: String
    let transactionIndex: Int
}

extension MyApiInfoTransactionBeforeSend: Unboxable {
    init(unboxer: Unboxer) throws {
        self.blockHash = try unboxer.unbox(keyPath: "blockHash")
        self.blockNumber = try unboxer.unbox(keyPath: "blockNumber")
        self.contractAddress = try? unboxer.unbox(keyPath: "contractAddress")
        self.gasUsed = try unboxer.unbox(keyPath: "gasUsed")
        self.root = try unboxer.unbox(keyPath: "root")
        self.to = try unboxer.unbox(keyPath: "to")
        self.from = try unboxer.unbox(keyPath: "from")
        self.transactionHash = try unboxer.unbox(keyPath: "transactionHash")
        self.transactionIndex = try unboxer.unbox(keyPath: "transactionIndex")
    }
}


//"infoTransaction": {
//    "blockHash": "0xcbb4b492a537b47b0caedbdf2132e48ebc6c26f8b639e596376ae8ba70f544dd",
//    "blockNumber": 4517,
//    "contractAddress": null,
//    "cumulativeGasUsed": 21000,
//    "from": "0x5700fa0f3cabf3fff8d4826dde8f71526ed1b288",
//    "gasUsed": 21000,
//    "logs": [],
//    "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
//    "root": "0x344d2a02cd68b312d771f8b99b3c6aae1b4f13563096979ecfee62d1548a8926",
//    "to": "0x88dda2d23a7cfc22a7fd603bc82dd739bf66ba92",
//    "transactionHash": "0x7c5ee0784258f45da939269613933cbe3305286d4392dbe9f6916bbbc7f81922",
//    "transactionIndex": 0
//}
