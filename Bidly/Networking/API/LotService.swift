//
//  LotService.swift
//  Bidly
//
//  Created by Baytik  on 16/4/25.
//

import Foundation

class LotService {
    static let shared = LotService()

    func publishLot(viewModel: CreateLotViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://httpbin.org/post") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Здесь подставляем токен в Authorization
        if let accessToken = TokenManager.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let payload: [String: Any] = [
            "title": viewModel.title ?? "",
            "category": viewModel.category ?? "",
            "price": viewModel.startPrice ?? 0,
            "minBidStep": viewModel.minBidStep ?? 0,
            "endDate": viewModel.endDate?.iso8601String() ?? "",
            "description": viewModel.lotDescription ?? ""
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
