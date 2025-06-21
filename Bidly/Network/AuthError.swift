//
//  AuthError.swift
//  Bidly
//
//  Created by Baytik  on 21/5/25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case refreshFailed
    case registrationFailed
    case unknown
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Неверный логин или пароль."
        case .refreshFailed:
            return "Не удалось обновить токен."
        case .registrationFailed:
            return "Не удалось зарегистрироваться."
        case .unknown:
            return "Неизвестная ошибка."
        case .invalidURL:
            return "Неверный URL"
        }
    }
}
