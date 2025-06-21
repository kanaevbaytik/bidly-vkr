//
//  Data.swift
//  Bidly
//
//  Created by Baytik  on 21/6/25.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
