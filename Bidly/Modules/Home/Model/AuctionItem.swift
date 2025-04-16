//
//  AuctionItem.swift
//  Bidly
//
//  Created by Baytik  on 12/3/25.
//

import Foundation

struct AuctionItem {
    let imageName: String
    let title: String
    let category: String
    let lastBid: Int
    let endDate: Date
    let description: String
    let sellerName: String
    let imageNames: [String]
}

//extension AuctionItem {
//    func formattedEndDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy HH:mm"
//        return formatter.string(from: endDate)
//    }
//}
