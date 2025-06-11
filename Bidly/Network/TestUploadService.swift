//
//  TestUploadService.swift
//  Bidly
//
//  Created by Baytik  on 12/6/25.
//
import Foundation
import UIKit

final class TestUploadService {
    
    static let shared = TestUploadService() //синглтон ебанный
    private init() {}
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "http://172.20.10.3:8050/auction/upload/withParam")!

    func uploadLotWithImage(
        title: String,
        category: String,
        startPrice: Int,
        minBidStep: Int,
        image: UIImage,
        imageFilename: String,
        completion: @escaping (Result<ServerResponseModel, Error>) -> Void
    ) {
        guard let accessToken = KeychainManager.shared.get("accessToken") else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        var body = Data()
        
        // Параметры
        let params: [String: Any] = [
            "title": title,
            "category": category,
            "startPrice": startPrice,
            "minBidStep": minBidStep
        ]
        
        for (key, value) in params {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Фото
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(imageFilename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                completion(.failure(NSError(domain: "Ошибка ответа сервера", code: 500)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
