//
//  AuthInterceptor.swift
//  Bidly
//
//  Created by Baytik  on 28/4/25.
//


import Foundation

final class AuthInterceptor {
    static let shared = AuthInterceptor()

    private init() {}

    func handleIfUnauthorized<T: Decodable>(_ endpoint: Endpoint, retryRequest: @escaping () async throws -> T) async throws -> T {
        do {
            return try await retryRequest()
        } catch let error as APIError {
            if case .unauthorized = error {
                // Попробовать обновить токен
                try await AuthService.shared.refreshToken()

                // После обновления токена повторяем запрос
                return try await retryRequest()
            } else {
                throw error
            }
        }
    }
}
