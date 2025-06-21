//
//  AuthService.swift
//  Bidly
//
//  Created by Baytik  on 19/5/25.
//
import Foundation

final class AuthService {
    static let shared = AuthService()
    private var baseURL = API.baseURL
    private let storage: TokenStorage

    init(storage: TokenStorage = KeychainManager.shared) {
        self.storage = storage
    }

    // MARK: - Регистрация
    func register(user: RegisterRequest) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/registrations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw AuthError.registrationFailed
        }
        
        // Парсим и сохраняем токены, как при login
        guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            throw AuthError.invalidCredentials
        }

        saveTokens(from: authResponse)
        return authResponse
    }


    // MARK: - Авторизация
    func login(user: UserCredentials) async throws -> AuthResponse {
        print("base url = ", baseURL)
        guard let url = URL(string: "\(baseURL)/account/auth/loginWith") else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "username=\(user.username)&password=\(user.password)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            throw AuthError.invalidCredentials
        }

        saveTokens(from: authResponse)
        return authResponse
    }

    // MARK: - Обновление токена
    func refreshToken() async throws -> AuthResponse {
        guard let refreshToken = storage.get("refreshToken") else {
            throw AuthError.refreshFailed
        }
        
        let url = URL(string: "\(baseURL)/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "client_id=ios-app&grant_type=refresh_token&refresh_token=\(refreshToken)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
            throw AuthError.refreshFailed
        }

        saveTokens(from: authResponse)
        return authResponse
    }

    // MARK: - Проверка валидности
    func isAccessTokenValid() -> Bool {
        guard let expiresString = storage.get("expiresAt"),
              let timestamp = Double(expiresString) else {
            return false
        }
        return Date() < Date(timeIntervalSince1970: timestamp)
    }

    // MARK: - Выход
    func logout() {
        storage.delete("accessToken")
        storage.delete("refreshToken")
        storage.delete("expiresAt")
    }

    // MARK: - Сохранение токена
    private func saveTokens(from response: AuthResponse) {
        let tokenData = response.toTokenData()
        storage.save(tokenData.accessToken, for: "accessToken")
        storage.save(tokenData.refreshToken, for: "refreshToken")
        storage.save(String(tokenData.expiresAt.timeIntervalSince1970), for: "expiresAt")
    }
}
