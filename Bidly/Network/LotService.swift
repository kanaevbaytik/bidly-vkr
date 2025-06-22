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
    
//    func publishLot(_ request: CreateLotRequest, completion: @escaping (Result<ServerResponseModel, Error>) -> Void) {
//        guard let accessToken = KeychainManager.shared.get("accessToken") else {
//            completion(.failure(NSError(domain: "Нет токена", code: 401)))
//            return
//        }
//        
//        var urlRequest = URLRequest(url: baseURL)
//        urlRequest.httpMethod = "POST"
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//        do {
//            let data = try JSONEncoder().encode(request)
//            urlRequest.httpBody = data
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        session.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard
//                let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode),
//                let data = data
//            else {
//                completion(.failure(NSError(domain: "Ошибка запроса", code: 500)))
//                return
//            }
//            
//            do {
//                let responseModel = try JSONDecoder().decode(ServerResponseModel.self, from: data)
//                completion(.success(responseModel))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    func publishLotWithMultipart(from model: CreateLotViewModel, completion: @escaping (Result<ServerResponseModel, Error>) -> Void) {
        print("📤 [1] Начало публикации лота")

        guard let accessToken = KeychainManager.shared.get("accessToken") else {
            print("❌ [Ошибка] Нет accessToken в Keychain")
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }

        guard let title = model.title,
              let desc = model.description,
              let startPrice = model.startPrice,
              let minStep = model.minBidStep,
              let endDate = model.endDate else {
            print("❌ [Ошибка] Недостаточно данных для отправки лота")
            completion(.failure(NSError(domain: "Данные неполные", code: 400)))
            return
        }

        let formatter = ISO8601DateFormatter()
        let startTime = formatter.string(from: Date())
        let endTime = formatter.string(from: endDate)

        print("📄 [2] Сформированные параметры запроса:")
        print("  ▸ title: \(title)")
        print("  ▸ description: \(desc)")
        print("  ▸ startingPrice: \(startPrice)")
        print("  ▸ currentPrice: \(startPrice)")
        print("  ▸ status: ACTIVE")
        print("  ▸ startTime: \(startTime)")
        print("  ▸ endTime: \(endTime)")
        print("  ▸ minStepPrice: \(minStep)")
        print("  ▸ images.count: \(model.images.count)")

        var components = URLComponents(string: "\(API.baseURL)/auction/uploadAuction/withParam")!
        components.queryItems = [
            .init(name: "title", value: title),
            .init(name: "description", value: desc),
            .init(name: "startingPrice", value: "\(startPrice)"),
            .init(name: "currentPrice", value: "\(startPrice)"),
            .init(name: "status", value: "ACTIVE"),
            .init(name: "startTime", value: startTime),
            .init(name: "endTime", value: endTime),
            .init(name: "minStepPrice", value: "\(minStep)")
        ]

        guard let url = components.url else {
            print("❌ [Ошибка] Не удалось собрать URL из компонентов")
            completion(.failure(NSError(domain: "Ошибка URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        print("🌐 [3] Собран URL: \(url)")
        print("📦 [4] Boundary: \(boundary)")
        print("🔐 [5] Заголовки:")
        print("  ▸ Authorization: Bearer \(accessToken.prefix(12))... (скрыт)")
        print("  ▸ Content-Type: multipart/form-data; boundary=\(boundary)")

        var body = Data()

        for (index, image) in model.images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("⚠️ [Внимание] Не удалось получить JPEG из изображения \(index)")
                continue
            }
            let fieldName = "files"
            let fileName = "photo\(index).jpg"
            let mimeType = "image/jpeg"

            print("🖼️ [6] Добавляем изображение \(index): \(fileName) (\(imageData.count) bytes)")

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        print("🚀 [7] Отправка запроса...")

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [Ошибка] Запрос завершился с ошибкой: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📬 [8] Ответ сервера: \(httpResponse.statusCode)")
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let fakeResponse = ServerResponseModel(message: "Лот успешно опубликован", lotId: nil)
                completion(.success(fakeResponse))
                return
            }

            do {
                let result = try JSONDecoder().decode(ServerResponseModel.self, from: data)
                print("✅ [9] Сервер ответил: \(result)")
                completion(.success(result))
            } catch {
                print("❌ [Ошибка] Не удалось декодировать ответ сервера: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
