//
//  Date.swift
//  Bidly
//
//  Created by Baytik  on 18/4/25.
//

import Foundation

extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
