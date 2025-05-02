//
//  AuthService.swift
//  Bidly
//
//  Created by Baytik  on 27/4/25.
//

import Foundation

struct TokensResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    private let baseURL = URL(string: "https://your-keycloak-domain.com")!
    private let clientID = "your-client-id"
    private let clientSecret = "your-client-secret"
    private let realm = "your-realm"
    
    func refreshToken(refreshToken: String) async throws -> TokensResponse {
        let url = baseURL.appendingPathComponent("/realms/\(realm)/protocol/openid-connect/token")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var params = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": clientID
        ]
        
        // Добавляем секрет только если он есть
        if !clientSecret.isEmpty {
            params["client_secret"] = clientSecret
        }
        
        request.httpBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(TokensResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func refreshToken() async throws {
        guard let currentRefreshToken = TokenManager.shared.refreshToken else {
            throw TokenError.missingRefreshToken
        }
        let newTokens = try await refreshToken(refreshToken: currentRefreshToken)
        TokenManager.shared.saveTokens(accessToken: newTokens.accessToken, refreshToken: newTokens.refreshToken)
    }
}

enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case decodingError
}
