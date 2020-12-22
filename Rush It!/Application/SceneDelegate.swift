//
//  SceneDelegate.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return assertionFailure("window scene casting error") }
		window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else {
			return assertionFailure("window optional value getting error")
		}
		window.windowScene = windowScene
		let navigationController = UINavigationController(rootViewController: Assembly.makeSomeDayListModule())
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}

