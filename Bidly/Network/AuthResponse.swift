//
//  AuthResponse.swift
//  Bidly
//
//  Created by Baytik  on 21/5/25.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
    
    func toTokenData() -> TokenData {
        let expiration = Date().addingTimeInterval(TimeInterval(expiresIn))
        return TokenData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiration
        )
    }
}

struct TokenData {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

