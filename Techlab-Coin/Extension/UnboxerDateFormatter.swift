//
//  UnboxerDateFormatter.swift
//  Techlab-Coin
//
//  Created by Hoang Trong Anh on 7/19/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import Foundation

class UnboxDateFormater {
    public static func date(format: String = "yyyy-mm-dd'T'H:m:s.sss'Z'") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
