//
//  AppDelegate.swift
//  Note
//
//  Created by Paul Young.
//

import CloudKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		application.registerForRemoteNotifications()
		return true
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		let dict = userInfo as! [String: NSObject]
		let notification = CKNotification(fromRemoteNotificationDictionary: dict)
		let db = CloudKitNoteDatabase.shared
        if notification?.subscriptionID == db.subscriptionID {
			db.handleNotification()
			completionHandler(.newData)
		}
		else {
			completionHandler(.noData)
		}
	}
}

