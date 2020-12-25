//
//  AppDelegate.swift
//  Rush It!
//
//  Created by Владислав Банков on 18.12.2020.
//

import UIKit
import RealmSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		var config = Realm.Configuration(
			schemaVersion: 1,
			migrationBlock: { migration, oldSchemaVersion in
				if (oldSchemaVersion < 1) {}
		})
		config.deleteRealmIfMigrationNeeded = true

		Realm.Configuration.defaultConfiguration = config

		_ = try! Realm()
		return true
	}
}

