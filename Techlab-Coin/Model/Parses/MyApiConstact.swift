//
//  MyApiConstact.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiConstact {
    let address: String
}

extension MyApiConstact: Unboxable {
    init(unboxer: Unboxer) throws {
        self.address = try unboxer.unbox(keyPath: "address")
    }
}
