//
//  String.swift
//  Bidly
//
//  Created by Baytik  on 30/5/25.
//

import Foundation


extension String {
    func isValidEmail() -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
