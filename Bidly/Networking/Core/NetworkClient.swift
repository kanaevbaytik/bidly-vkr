//
//  NetworkClient.swift
//  Bidly
//
//  Created by Baytik  on 28/4/25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await AuthInterceptor.shared.handleIfUnauthorized(endpoint) {
            try await self.performRequest(endpoint)
        }
    }
    
    private func performRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode(T.self, from: data)
        case 401:
            throw APIError.unauthorized
        default:
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
    }
}
