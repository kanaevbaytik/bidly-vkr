//
//  LotService.swift
//  Bidly
//
//  Created by Baytik  on 16/4/25.
//

import Foundation

class LotService {
    static let shared = LotService()

    func publishLot(title: String, price: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        // Пример URL — замени на настоящий адрес своего сервера
        guard let url = URL(string: "https://postman-echo.com/post") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "title": title,
            "price": price
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: -2)))
                return
            }

            completion(.success(()))
        }.resume()
    }
}
