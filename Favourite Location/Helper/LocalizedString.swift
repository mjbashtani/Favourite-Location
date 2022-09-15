//
//  LocalizedString.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation

struct LocalizedString {
    var key: String

    init(_ key: String) {
        self.key = key
    }

    func resolve() -> String {
        NSLocalizedString(key,tableName: "Shared", comment: "")
    }
}

extension LocalizedString: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        key = value
    }
}
