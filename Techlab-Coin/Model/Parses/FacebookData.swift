//
//  FacebookData.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct FacebookData {
    let name: String
    let email: String
    let profilepic: URL?
}

extension FacebookData: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(keyPath: "name")
        self.email = try unboxer.unbox(keyPath: "email")
        self.profilepic = try? unboxer.unbox(keyPath: "picture.data.url")
    }
}
