//
//  FilterListTableViewController.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 08/06/2023.
//

import UIKit

final class FilterListTableViewController: UITableViewController {
    weak var delegate: ViewControllerDelegate?
    let userDefaultsManager: UserDefaultsStorage = UserDefaultsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
    }
    
    @objc func didTapBackButton() {
        delegate?.navigateBackToMainViewController()
    }
    
    private func setUpNavigationItem() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Filters"
    }
}

// MARK: TableViewDataSource
extension FilterListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaultsManager.filtersArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = userDefaultsManager.filtersArray[indexPath.row]
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = userDefaultsManager.filtersArray[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userDefaultsManager.remove(filterAt: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if userDefaultsManager.filtersArray.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.delegate?.navigateBackToMainViewController()
                }
            }
        }
    }
}

// MARK: TableViewDelegate
extension FilterListTableViewController {
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
