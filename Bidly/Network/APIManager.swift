//
//  APIManager.swift
//  Bidly
//
//  Created by Baytik  on 19/5/25.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    private let authService = AuthService.shared
    private let storage = KeychainManager.shared
    

    func fetchProtectedData() async throws -> String {
        guard let accessToken = storage.get("accessToken") else {
            throw AuthError.invalidCredentials
        }

        let url = URL(string: "https://your-api-gateway.com/protected-route")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                _ = try await authService.refreshToken()
                return try await fetchProtectedData()
            }

            guard let responseString = String(data: data, encoding: .utf8) else {
                throw AuthError.unknown
            }

            return responseString
        } catch {
            throw error
        }
    }
}

