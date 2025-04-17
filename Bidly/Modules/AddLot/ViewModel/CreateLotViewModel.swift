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
    var lotDescription: String?
    
    // MARK: - Computed Properties
    var isReadyToSubmit: Bool {
        return title != nil &&
        category != nil &&
        startPrice != nil &&
        minBidStep != nil &&
        endDate != nil &&
        !images.isEmpty &&
        lotDescription != nil
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
        self.lotDescription = desc
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





