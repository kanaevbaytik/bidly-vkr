//
//  AppDelegate.swift
//  Bidly
//
//  Created by Baytik  on 3/3/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("🟣 AppDelegate запущен без Firebase и пушей")
        return true
    }

    // MARK: UISceneSession Lifecycle (если используешь UISceneDelegate)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Здесь можно очищать ресурсы, если нужно
    }
}

