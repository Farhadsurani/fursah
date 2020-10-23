//
//  AppDelegate.swift
//  Fursahh
//
//  Created by Akber Sayni on 29/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import CoreLocation
import Firebase
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var location: CLLocation?
    let locationManager = CLLocationManager()
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
        setupLocationManager()
        setupRemoteNotification(application)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

extension AppDelegate {
    public func loadHomeViewController() {
        // Register user device token
        if let token = AppStateManager.shared.getDeviceToken() {
            Constants.APP_DELEGATE.registerDeviceToken(token)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeTabBarViewController")
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.window?.rootViewController = controller
        }, completion: nil)
    }
	
	func showLoginViewController() {
		if let topController = Utility().topViewController() {
			let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
			let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
			controller.isShowCrossButton = true
			topController.present(controller, animated: true, completion: nil)
		}
	}
    
    public func loadLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.window?.rootViewController = controller
        }, completion: nil)
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .denied:
            Utility.showMessageAlert(message: "user_location_denied_message".localized)
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
}

// MARK: - FCM Integration
extension AppDelegate {
    private func setupRemoteNotification(_ application: UIApplication) {
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppStateManager.shared.saveDeviceToken(fcmToken)
        self.registerDeviceToken(fcmToken)
        
        // let fcmToken : [String: String] = ["Token": fcmToken]
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        //        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: fcmToken)
        
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

// MARK: - Web API Methods
extension AppDelegate {
    public func registerDeviceToken(_ token: String) {
        if let userId = AppStateManager.shared.getUserId() {
            let params: [String: Any] = [
                "user_id": userId,
                "type": "ios",
                "push_id": token
            ]
            APIManager.sharedInstance.user.registerDeviceToken(params: params, success: { (success) in
                print("device token registered")
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

