//
//  UserCredentials.swift
//  Bidly
//
//  Created by Baytik  on 21/5/25.
//

import Foundation

struct UserCredentials: Codable {
    let username: String
    let password: String
}

struct RegisterRequest {
    let name: String
    let email: String
    let password: String
}
