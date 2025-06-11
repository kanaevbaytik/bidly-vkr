//
//  LotService.swift
//  Bidly
//
//  Created by Baytik  on 10/6/25.
//

import Foundation

final class LotService {
    
    static let shared = LotService()
    private init() {}
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "http://172.20.10.3:8050/auction/upload/withParam")! // замени на свой URL
    
    func publishLot(_ request: CreateLotRequest, completion: @escaping (Result<ServerResponseModel, Error>) -> Void) {
        guard let accessToken = KeychainManager.shared.get("accessToken") else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }
        
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONEncoder().encode(request)
            urlRequest.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                completion(.failure(NSError(domain: "Ошибка запроса", code: 500)))
                return
            }
            
            do {
                let responseModel = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
