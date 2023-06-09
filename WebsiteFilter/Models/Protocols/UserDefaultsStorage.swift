//
//  UserDefaultsProtocol.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 09/06/2023.
//

import Foundation

protocol UserDefaultsStorage {
    var filtersArray: [String] { get }
    func remove(filterAt indexPath: IndexPath)
    func insert(filter: String)
}
