//
//  AuctionItem.swift
//  Bidly
//
//  Created by Baytik  on 12/3/25.
//

import Foundation

struct AuctionItem {
    let id: String
    let imageName: String
    let title: String
    let category: Category
    let startPrice: Int
    let lastBid: Int
    let endDate: Date
    let description: String
    let sellerName: String
    let itemImages: [ItemImageResponse]
//    let imageNames: [String?]
}
