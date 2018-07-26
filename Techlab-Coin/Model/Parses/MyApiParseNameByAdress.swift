//
//  MyApiParseNameByAdress.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/26/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct MyApiNameEmailByAdress {
    let name: String
}

extension MyApiNameEmailByAdress: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(keyPath: "name")
    }
}
