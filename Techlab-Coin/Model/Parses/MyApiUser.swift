//
//  MyApiUser.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/19/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiUser {
    let name: String
    let address: String
    let datetime: Date
}

extension MyApiUser: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(keyPath: "name")
        self.address = try unboxer.unbox(keyPath: "address")
        self.datetime = try unboxer.unbox(keyPath: "datetime", formatter: UnboxDateFormater.date())
    }
}
