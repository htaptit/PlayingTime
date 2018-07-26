//
//  MyApiConstacts.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiConstacts {
    let constacts: [MyApiConstact]
}

extension MyApiConstacts: Unboxable {
    init(unboxer: Unboxer) throws {
        self.constacts = try unboxer.unbox(keyPath: "constacts")
    }
}
