//
//  MyApiParseEmailByName.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiParseEmailByName {
    let email: String
    let type: Int
}

extension MyApiParseEmailByName: Unboxable {
    init(unboxer: Unboxer) throws {
        self.email = try unboxer.unbox(keyPath: "email")
        self.type = try unboxer.unbox(keyPath: "type")
    }
}
