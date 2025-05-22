//
//  TokenStorage.swift
//  Bidly
//
//  Created by Baytik  on 21/5/25.
//

import Foundation

protocol TokenStorage {
    func save(_ value: String, for key: String)
    func get(_ key: String) -> String?
    func delete(_ key: String)
}
