//
//  UserDefaultsManager.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 09/06/2023.
//

import Foundation

class UserDefaultsManager: UserDefaultsStorage {
    var filtersArray: [String] {
        var filtersArray: [String] = []
        if let userDefaultsArray = UserDefaults.standard.array(forKey: UserDefaultsKeys.filtersArray.rawValue) as? [String] {
            filtersArray = userDefaultsArray
        } else {
            UserDefaults.standard.set(filtersArray, forKey: UserDefaultsKeys.filtersArray.rawValue)
        }
        return filtersArray
    }
    
    func remove(filterAt indexPath: IndexPath) {
        var newFiltersArray = filtersArray
        newFiltersArray.remove(at: indexPath.row)
        UserDefaults.standard.set(newFiltersArray, forKey: UserDefaultsKeys.filtersArray.rawValue)
    }
    
    func insert(filter: String) {
        guard !filtersArray.contains(filter) else { return }
        var newFiltersArray = filtersArray
        newFiltersArray.insert(filter, at: 0)
        UserDefaults.standard.set(newFiltersArray, forKey: UserDefaultsKeys.filtersArray.rawValue)
    }
}
