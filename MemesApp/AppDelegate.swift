//
//  AppDelegate.swift
//  MemesApp
//
//  Created by Николай Игнатов on 03.02.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let networkService = NetworkService()
        let memesViewController = MemesFactory.makeModule(networkService: networkService)
        window?.rootViewController = memesViewController
        window?.makeKeyAndVisible()
        return true
    }
}
