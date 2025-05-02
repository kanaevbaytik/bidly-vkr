//
//  Category.swift
//  Bidly
//
//  Created by Baytik  on 5/3/25.
//

enum Category: String, CaseIterable {
    case electronics = "Электроника"
    case auto = "Авто"
    case forChildren = "Для детей"
    case sport = "Спорт"
    case home = "Дом"
    case furniture = "Мебель"
    case rare = "Редкое"
    case other = "Другое"
    
    var imageName: String {
        switch self {
        case .electronics: return "electronic"
        case .auto: return "auto"
        case .forChildren: return "forChildren"
        case .sport: return "sport"
        case .home: return "dom"
        case .furniture: return "mebel"
        case .rare: return "redkoe"
        case .other: return "drugoe"
        }
    }
}

