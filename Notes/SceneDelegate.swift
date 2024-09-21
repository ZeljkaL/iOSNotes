//
//  SceneDelegate.swift
//  Notes
//
//  Created by Zeljka Lazarevic on 13. 9. 2024..
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks that were paused.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle tasks when the scene becomes inactive.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when entering background.
        CoreDataManager.shared.save()
    }
}
