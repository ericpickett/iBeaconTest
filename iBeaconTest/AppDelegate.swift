//
//  AppDelegate.swift
//  iBeaconTest
//
//  Created by eric on 2020/07/07.
//  Copyright © 2020 BizMobile. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow()
        guard let unwrappedWindow = self.window else { fatalError() }
        unwrappedWindow.backgroundColor = .white
        let initialViewController = HomeViewController()
        unwrappedWindow.rootViewController = initialViewController
        unwrappedWindow.makeKeyAndVisible()
        
        print("launched: \(Date())")
        
        LocationManager.shared.requestAlwaysAuthorization()
        
        let uuid = UUID(uuidString: "b8e688e6-c021-11ea-91c6-645aede93167")
        let id = "jp.co.bizmobile.iBeaconTest"
        let major = CLBeaconMajorValue(bitPattern: 1)
        let minor = CLBeaconMinorValue(bitPattern: 1)
        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: id)
        LocationManager.shared.startMonitoring(for: region)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { successful, error in
            if let errorDescription = error?.localizedDescription {
                os_log("Error in notification authorization: %s", errorDescription)
            }
        })
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("backgrounded: \(Date())")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}
