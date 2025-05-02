//
//  TokenManager.swift
//  Bidly
//
//  Created by Baytik  on 28/4/25.
//

import Foundation
import Security

final class TokenManager {
    static let shared = TokenManager()
    private init() {}

    private let accessTokenKey = "com.yourApp.accessToken"
    private let refreshTokenKey = "com.yourApp.refreshToken"
    
    // Кэшируем токены в памяти для быстрого доступа
    private var _accessToken: String?
    private var _refreshToken: String?

    var accessToken: String? {
        get {
            // Если есть в памяти - возвращаем
            if let token = _accessToken {
                return token
            }
            // Иначе загружаем из Keychain
            let token = KeychainHelper.shared.get(forKey: accessTokenKey)
            _accessToken = token
            return token
        }
        set {
            _accessToken = newValue
            if let token = newValue {
                KeychainHelper.shared.save(token, forKey: accessTokenKey)
            } else {
                KeychainHelper.shared.delete(forKey: accessTokenKey)
            }
        }
    }

    var refreshToken: String? {
        get {
            if let token = _refreshToken {
                return token
            }
            let token = KeychainHelper.shared.get(forKey: refreshTokenKey)
            _refreshToken = token
            return token
        }
        set {
            _refreshToken = newValue
            if let token = newValue {
                KeychainHelper.shared.save(token, forKey: refreshTokenKey)
            } else {
                KeychainHelper.shared.delete(forKey: refreshTokenKey)
            }
        }
    }

    func saveTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }

    func refreshAccessTokenIfNeeded() async throws {
        guard let refreshToken = self.refreshToken else {
            throw TokenError.missingRefreshToken
        }
        let newTokens = try await AuthService.shared.refreshToken(refreshToken: refreshToken)
        saveTokens(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
    }
}

enum TokenError: Error {
    case missingRefreshToken
    case failedToSaveToken
}
