//
//  AppDelegate.swift
//  WebsiteFilter
//
//  Created by Vladyslav Petrenko on 05/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        mainCoordinator = MainCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        mainCoordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}
