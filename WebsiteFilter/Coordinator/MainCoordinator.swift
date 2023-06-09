//
//  MainCoordinator.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 08/06/2023.
//

import UIKit

final class MainCoordinator: Coordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let initialViewController = MainViewController()
        initialViewController.delegate = self        
        navigationController.pushViewController(initialViewController, animated: false)
    }
}

// MARK: ViewControllerDelegate
extension MainCoordinator: ViewControllerDelegate {
    func navigateToFilterListTableViewController() {
        let destinationViewController: FilterListTableViewController
        if #available(iOS 13.0, *) {
            destinationViewController = FilterListTableViewController(style: .insetGrouped)
        } else {
            destinationViewController = FilterListTableViewController()
        }
        destinationViewController.delegate = self
        if destinationViewController.userDefaultsManager.filtersArray.isEmpty {
            (navigationController.visibleViewController as? MainViewController)?.presentOKAlertController(withTitle: "No Filters",
                                                                                                          message: "The filter list is empty")
        } else {
            navigationController.present(UINavigationController(rootViewController: destinationViewController), animated: true)
        }
    }
    
    func navigateBackToMainViewController() {
        navigationController.dismiss(animated: true)
    }
}
