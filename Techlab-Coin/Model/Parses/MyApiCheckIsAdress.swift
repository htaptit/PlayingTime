//
//  MyApiCheckIsAdress.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/24/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiCheckIsAddress {
    let isAddress: Bool
}

extension MyApiCheckIsAddress: Unboxable {
    init(unboxer: Unboxer) throws {
        self.isAddress = try unboxer.unbox(keyPath: "isAddress")
    }
}
