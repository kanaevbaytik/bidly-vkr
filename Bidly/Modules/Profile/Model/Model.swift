//
//  Model.swift
//  Bidly
//
//  Created by Baytik  on 19/4/25.
//

import Foundation

struct LotStorageModel: Codable {
    let title: String
    let category: String
    let startPrice: Double
    let minBidStep: Double
    let endDate: String
    let lotDescription: String
    let imageData: [Data] // UIImage → Data
}
