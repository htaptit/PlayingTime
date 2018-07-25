//
//  MyApiHistory.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox
import Timepiece

struct MyApiHistory {
    let transaction_hash: String
    var created_at: Date
    let name: String
    let email: String
    let type: Int
    let value: String
    let to_address: String
}

extension MyApiHistory: Unboxable {
    init(unboxer: Unboxer) throws {
        self.transaction_hash = try unboxer.unbox(keyPath: "transaction_hash")
        self.name = try unboxer.unbox(keyPath: "name")
        self.email = try unboxer.unbox(keyPath: "email")
        self.type = try unboxer.unbox(keyPath: "type")
        self.created_at = try unboxer.unbox(keyPath: "created_at", formatter: UnboxDateFormater.date())
        self.created_at = (self.created_at + 7.hour)!
        self.created_at = (self.created_at + 6.month)!
        
        self.value = try unboxer.unbox(keyPath: "value")
        self.to_address = try unboxer.unbox(keyPath: "to_address")
    }
}


//{
//    "id": 1,
//    "transaction_hash": "0x9632a2526109120ed41868e947109be5b766b6c2e43efbe24b413bd301831937",
//    "created_at": "2018-07-25T04:51:19.000Z",
//    "name": "dealer",
//    "email": "htaptit@gmail.com",
//    "type": 0
//}
