//
//  CreateLotViewModel.swift
//  Bidly
//
//  Created by Baytik  on 10/3/25.
//

import Foundation

class CreateLotViewModel {
    var title: String?
    var category: String?
    var location: String?
    var auctionDate: Date?
    var minBidStep: Double?
    var image: [Data] = []
    var description: String?
    
    init () {}
    
    func publishLot(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let title = title,
              let category = category,
              let location = location,
              let auctionDate = auctionDate,
              let minBidStep = minBidStep,
              let description = description else {
            completion(.failure(NSError(domain: "Missing fields", code: 400, userInfo: nil)))
            return
        }
        
        let url = URL(string: "https://your-api.com/api/lots")! // заменишь на нужный URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let lotData: [String: Any] = [
            "title": title,
            "category": category,
            "location": location,
            "auctionDate": ISO8601DateFormatter().string(from: auctionDate),
            "minBidStep": minBidStep,
            "description": description
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: lotData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
        task.resume()
    }
}



