//
//  AuctionAPI.swift
//  Bidly
//
//  Created by Baytik  on 11/6/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case unauthorized
}

final class AuctionAPI {
    static let shared = AuctionAPI()
    private init() {}

    func fetchPopularLots() async throws -> [AuctionItemResponse] {
        guard let url = URL(string: "http://172.20.10.3:8050/auction/items") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        
        if let token = KeychainManager.shared.get("accessToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw APIError.unauthorized
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        print("📦 Response JSON: ", String(data: data, encoding: .utf8) ?? "nil")
        
        let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            // Если хочешь декодировать startTime и endTime как Date:
//             decoder.dateDecodingStrategy = .iso8601
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: -6 * 3600)
        decoder.dateDecodingStrategy = .formatted(formatter)

            return try decoder.decode([AuctionItemResponse].self, from: data)
        
        


        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.unauthorized
        }

//        do {
//            let decoded = try JSONDecoder().decode([AuctionResponse].self, from: data)
//            return decoded
//        } catch {
//            throw APIError.decodingError
//        }
        do {
            let items = try decoder.decode([AuctionItemResponse].self, from: data)
            return items
        } catch {
            print("🔥 Ошибка декодирования:", error)
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("🔑 Ключ не найден: \(key.stringValue) — \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("❗ Несовпадение типа: \(type) — \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("🕳️ Значение не найдено: \(type) — \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("💥 Данные повреждены: \(context.debugDescription)")
                default:
                    print("❌ Другая ошибка: \(error)")
                }
            }
        }

    }
}
