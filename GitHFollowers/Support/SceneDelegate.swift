//
//  SceneDelegate.swift
//  GitHFollowers
//
//  Created by Afir Thes on 29.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = GFTabBarController()
        self.window?.makeKeyAndVisible()

        self.configureNavigationBar()
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }
}
