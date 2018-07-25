//
//  MyApiHistories.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/25/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiHistories {
    let history: [MyApiHistory]
}

extension MyApiHistories: Unboxable {
    init(unboxer: Unboxer) throws {
        self.history = try unboxer.unbox(keyPath: "history")
    }
}
