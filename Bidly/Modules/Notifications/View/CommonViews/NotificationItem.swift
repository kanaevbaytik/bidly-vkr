//
//  NotificationItem.swift
//  Bidly
//
//  Created by Baytik  on 20/4/25.
//

import UIKit

enum NotificationType {
    case bidPlaced
    case bidOutbid
    case message
    case donation
    case goalReached
    case generic
}

struct NotificationItem {
    let id: UUID = UUID()
    let type: NotificationType
    let title: String
    let subtitle: String?
    let date: Date
    let avatarImage: UIImage?
    let thumbnailImage: UIImage?
    let amount: String? // например: "5500 KGS", "$200"
    let isNew: Bool
}

struct NotificationSection {
    let title: String
    let items: [NotificationItem]
}
