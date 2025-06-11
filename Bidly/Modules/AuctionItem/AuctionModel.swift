//
//  AuctionModel.swift
//  Bidly
//
//  Created by Baytik  on 11/6/25.
//

import Foundation

//struct AuctionResponse: Decodable {
//    let id: String
//    let title: String
//    let description: String
//    let startingPrice: Double
//    let currentPrice: Double
//    let minStepPrice: Double?
//    let status: String
//    let startTime: String
//    let endTime: String
//    let itemImages: [AuctionImage]
//    let bids: [AuctionBid]
//    let category: String?
//}
//
//struct AuctionImage: Decodable {
//    let id: String
//    let imageUrl: String
//}
//
//struct AuctionBid: Decodable {
//    let id: String
//    let amount: Double
//    let timestamp: String
//    let userId: String
//}

struct AuctionItemResponse: Decodable {
    let id: String
    let title: String
    let description: String
    let startingPrice: Double
    let currentPrice: Double
    let minStepPrice: Double?
    let status: String?
    let startTime: String
    let endTime: Date
    let userId: String
    let bids: [BidResponse?]
    let itemImages: [ItemImageResponse]
    let category: String?

}

struct BidResponse: Decodable {
    let id: String
    let amount: Double
    let timestamp: String
    let userId: String
}

struct ItemImageResponse: Decodable {
    let id: String
    let imageUrl: String
}

