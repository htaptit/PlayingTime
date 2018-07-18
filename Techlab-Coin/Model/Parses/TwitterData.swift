//
//  TwitterData.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/16/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation
import Unbox

struct TwitterData {
    let name: String
    let email: String
    var profile_image_url_https_string: URL?
}

extension TwitterData: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(keyPath: "name")
        self.email = try unboxer.unbox(keyPath: "email")
        
        let profile_image_url_https: URL? = try? unboxer.unbox(keyPath: "profile_image_url_https")
        self.profile_image_url_https_string = nil
        if let url = profile_image_url_https {
            self.profile_image_url_https_string = URL(string: url.absoluteString.replacingOccurrences(of: "_normal", with: ""))
        }
    }
}
