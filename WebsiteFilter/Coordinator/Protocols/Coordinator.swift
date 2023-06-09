//
//  Coordinator.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 08/06/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    init(navigationController: UINavigationController)
    func start()
}
