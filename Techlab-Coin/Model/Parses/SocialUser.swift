//
//  User.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 15/07/2018.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation

enum TypeSocial: Int {
    case gmail = 0, facebook, twitter
}

struct SocialUser {
    let name: String
    let email: String
    let cover_url_string: String
    let type: TypeSocial
}
