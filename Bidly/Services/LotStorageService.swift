//
//  LotStorageService.swift
//  Bidly
//
//  Created by Baytik  on 19/4/25.
//

import Foundation

class LotStorageService {
    private static let key = "myLots"

    static func save(_ lot: LotStorageModel) {
        var lots = fetchAll()
        lots.append(lot)
        if let data = try? JSONEncoder().encode(lots) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func fetchAll() -> [LotStorageModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let lots = try? JSONDecoder().decode([LotStorageModel].self, from: data) else {
            return []
        }
        return lots
    }

    static func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
