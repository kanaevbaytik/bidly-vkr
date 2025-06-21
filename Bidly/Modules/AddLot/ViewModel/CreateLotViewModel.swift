//
//  CreateLotViewModel.swift
//  Bidly
//
//  Created by Baytik  on 10/3/25.
//

import Foundation
import UIKit

final class CreateLotViewModel {
    
    // MARK: - Lot Properties
    var title: String?
    var category: String?
    var startPrice: Double?
    var minBidStep: Double?
    var endDate: Date?
    var images: [UIImage] = []
    var description: String?
    
    // MARK: - Computed Properties
    var isReadyToSubmit: Bool {
        return title != nil &&
        category != nil &&
        startPrice != nil &&
        minBidStep != nil &&
        endDate != nil &&
        !images.isEmpty &&
        description != nil
    }
    
    // MARK: - Step 1: Set basic details
    func setBasicDetails(title: String?, category: String?, endDateString: String?) -> Bool {
        guard
            let title = title, !title.isEmpty,
            let category = category, !category.isEmpty,
            let dateStr = endDateString, !dateStr.isEmpty,
            let date = DateFormatter.lotDateFormatter.date(from: dateStr)
        else {
            return false
        }
        
        self.title = title
        self.category = category
        self.endDate = date
        
        print("✅ Title: \(title)")
        print("✅ Category: \(category)")
        print("✅ End Date: \(date)")
        return true
    }
    
    // MARK: - Step 2: Set pricing
    func setPricing(startPrice: Double?) -> Bool {
        guard let price = startPrice, price > 0 else {
            return false
        }
        
        self.startPrice = price
        self.minBidStep = (price * 0.05).rounded() // 5%
        
        print("💰 Start Price: \(price)")
        print("📈 Min Bid Step: \(self.minBidStep!)")
        return true
    }
    
    // MARK: - Step 3: Set images
    func setImages(_ images: [UIImage]) -> Bool {
        guard !images.isEmpty else {
            return false
        }
        
        self.images = images
        print("🖼️ Загружено изображений: \(images.count)")
        return true
    }
    
    //MARK: - Step 4: set description
    func setDescription(_ description: String?) -> Bool {
        guard let desc = description?.trimmingCharacters(in: .whitespacesAndNewlines), !desc.isEmpty else {
            return false
        }
        self.description = desc
        print("📝 Описание: \(desc)")
        return true
    }
}



extension DateFormatter {
    static let lotDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}

//MARK: - Модель для локального хранилища (в будущем нужно снести)

extension CreateLotViewModel {
    func toStorageModel() -> LotStorageModel? {
        guard
            let title = title,
            let category = category,
            let startPrice = startPrice,
            let minBidStep = minBidStep,
            let endDate = endDate,
            let lotDescription = description
        else { return nil }
        
        let imageData = images.compactMap { $0.jpegData(compressionQuality: 0.7) }
        
        let dateString = DateFormatter.lotDateFormatter.string(from: endDate)
        
        return LotStorageModel(
            title: title,
            category: category,
            startPrice: startPrice,
            minBidStep: minBidStep,
            endDate: dateString,
            lotDescription: lotDescription,
            imageData: imageData
        )
    }
}

//MARK: - Модель для отправки DTO

extension CreateLotViewModel {
    func toCreateRequest() -> CreateLotRequest? {
        guard
            let title = title,
            let category = category,
            let startPrice = startPrice,
            let minBidStep = minBidStep,
            let endDate = endDate,
            let lotDescription = description
        else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let endDateString = formatter.string(from: endDate)

        let imagesBase64 = images.compactMap { image -> String? in
            guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
            return data.base64EncodedString()
        }

        return CreateLotRequest(
            title: title,
            category: category,
            startPrice: startPrice,
            minBidStep: minBidStep,
            endDate: endDateString,
            description: lotDescription,
            images: images
        )
    }
}

//MARK: - Моковые структуры для теста сетевого слоя!
struct CreateLotRequest {
    let title: String
    let category: String
    let startPrice: Double
    let minBidStep: Double
    let endDate: String
    let description: String
    let images: [UIImage]
}

struct ServerResponseModel: Codable {
    let message: String
    let lotId: Int?
}


struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}


