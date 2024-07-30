//
//  AppDelegate.swift
//  leaflet
//
//  Created by 제현 on 7/16/24.
//

import UIKit
import Nuke
import FirebaseCore
import FirebaseMessaging
import FirebaseFirestore

let dataCache = try? DataCache(name: "com.blink.leaflet")

var fcm_id: String = ""
var numberFormat: NumberFormatter = NumberFormatter()

var platform_type: String = ""
var device_info: String = ""
var device_ratio: String = ""
var device_radius: CGFloat = 0.0

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var backSwipeGesture: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        memoryCheck()
        UIViewController.swizzleViewDidDisappear()
        // init
        numberFormat.numberStyle = .decimal
        deviceInfo { ratio, device in
            platform_type = UIDevice.current.systemName
            device_info = device
            device_ratio = ratio
        }
        if device_ratio == "16:9" {
            device_radius = 5
        } else if device_ratio == "18:9" {
            device_radius = 30
        } else if device_ratio == "19:9" {
            device_radius = 50
        }
        /// Firebase init
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = false
        /// Notification Push init
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, Error in
            if fcm_id == "" { Messaging.messaging().token { token, error in fcm_id = token ?? "" } }
        })
        application.registerForRemoteNotifications()
        /// first segue
        let segue = storyboard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let root = UINavigationController(rootViewController: segue)
        root.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = root; window?.makeKeyAndVisible()
        
        return true
    }

}

