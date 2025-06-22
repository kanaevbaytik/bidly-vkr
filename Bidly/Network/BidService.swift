//
//  BidService.swift
//  Bidly
//
//  Created by Baytik  on 21/6/25.
//

import Foundation

final class BidService {
    
    static let shared = BidService()
    private init() {}

    func placeBid(amount: Int, auctionItemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = KeychainManager.shared.get("accessToken") else {
            print("❌ Нет токена в Keychain")
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }

        var components = URLComponents(string: "\(API.baseURL)/auction/bid/")!
        components.queryItems = [
            .init(name: "amount", value: "\(amount)"),
            .init(name: "auctionItemId", value: auctionItemId)
        ]

        guard let url = components.url else {
            print("❌ Ошибка: невалидный URL")
            completion(.failure(NSError(domain: "Ошибка URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        print("🚀 Отправка ставки: \(url)")
        print("🔐 Токен: \(accessToken.prefix(12))...")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Сетевая ошибка:", error)
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📬 Код ответа: \(httpResponse.statusCode)")
                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "Ошибка сервера", code: httpResponse.statusCode)))
                }
            } else {
                completion(.failure(NSError(domain: "Нет HTTP ответа", code: 500)))
            }
        }.resume()
    }
}
