//
//  APIManager.swift
//  Bidly
//
//  Created by Baytik  on 4/3/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case noData
    case decodingFailed
}

final class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "https://jsonplaceholder.typicode.com"

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            print("🔽 Raw server response:")
            print(String(data: data, encoding: .utf8) ?? "❌ Unable to decode response to string")


            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingFailed))
            }
        }

        task.resume()
    }
}

