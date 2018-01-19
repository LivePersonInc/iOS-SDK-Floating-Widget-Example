//
//  AppDelegate.swift
//  FloatingAction
//
//  Created by David Villacis on 1/10/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//

import UIKit
// Required Import to access LPMesssagingSDKDelegate
import LPMessagingSDK
// Required Import to access Notification
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LPMessagingSDKNotificationDelegate, LivePersonAPIDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  
  // MARK: - App LifeCycle
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Set Status Bar Style - Light Bar (White Font)
    application.statusBarStyle = .lightContent
    // Check if iOS 10.0+
    if #available(iOS 10.0, *){
      // Request Authorization for Push Notifications
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
        // Check if Granted Permissions
        if granted {
          // Dispatch Main Queue - in iOS 10.0+ Notifications should be register in Main Queue
          DispatchQueue.main.async {
            // Register for Push
            application.registerForRemoteNotifications()
          }
        } else {
          //
          print("User Authorization :: Denied")
        }
      })
    } else {
      // Register for Push Notification - UIUserNotificationSettings - Deprecated on iOS 10.0
      application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
      // Register for Notifications
      application.registerForRemoteNotifications()
    }
    // Init LivePersonAPI Delegate
    LivePersonAPI.shared.delegate = self
    // Override point for customization after application launch.
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
    // Get Unread Messages Count
    LivePersonAPI.shared.getUnreadMessagesCount()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
  }
  
  // MARK: - Notification Delegates
  
  /// App Did Register for Push Notifications
  ///
  /// - Parameters:
  ///   - application: Application Instance
  ///   - deviceToken: Device Token for Push Notifications
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Get Token & Parse it
    let token = deviceToken.map{ String( format : "%02.2hhx",$0)}.joined()
    // Print Token
    print("Token:: \(token)")
    // Register Token on LPMesssagingSDK Instance
    LPMessagingSDK.instance.registerPushNotifications(token: deviceToken, notificationDelegate: self)
  }
  
  /// App did Receive Remote Notification
  ///
  /// - Parameters:
  ///   - application: Application Instance
  ///   - userInfo: Notification Information
  ///   - completionHandler: Completition Handler
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Get Unread Messages Count
    if let badge = userInfo["badge"] as? Int {
      // Update Badge
      self.updateUnreadMessagesButton(badge)
    }
    // Handle Push LP Notification
    LPMessagingSDK.instance.handlePush(userInfo)
  }
  // MARK: - LPMessagingSDKNotificationDelegate Delegates
  
  /// Will handle custom behavior if LP Push Notification was touch
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(didReceivePushNotification notification: LPNotification) {
    // TODO : Add custom behavior for User Tapping Push Notification
    if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
      // Show Messaging Screen
      self.showMessaging()
    }
  }
  
  /// This method will hide/show the In-App Push Notification
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: true for showing Push Notifications/ false for hidding In-App Push Notification
  func LPMessagingSDKNotification(shouldShowPushNotification notification: LPNotification) -> Bool {
    // Return false if you don't want to show In-App Push Notification
    return true
  }
  
  /// Override SDK - In-App Push Notification
  /// Behavior for tapping In-App Notification should be handle, when using a custom view no behavior is added, LPMessagingSDKNotification(notificationTapped) can't be use
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  /// - Returns: Custom View
  // TODO : Implement this method to Override Native In-App Notification
  // func LPMessagingSDKNotification(customLocalPushNotificationView notification: LPNotification) -> UIView {
  // Return Custom Toast View
  // return UIView()
  // }
  
  /// This method is override when using a Custom View for the In-App Notification (LPMessagingSDKNotification(customLocalPushNotificationView)
  /// Add Custom Behavior to LPMessaging Toast View being Tap
  ///
  /// - Parameter notification: LP Notification ( text, user: Agent(firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid), accountID , isRemote: Bool)
  func LPMessagingSDKNotification(notificationTapped notification: LPNotification) {
    // TODO : Add custom behavior for User Tapping In-App Notification (Toast)
    self.showMessaging()
  }
  
  // MARK: - LivePersonAPI Delegate
  
  /// Will return Unread Messages Count from LPMessagingSDK
  func didFinishFetchgingUnreadMessagesCount(_ count: Int) {
    // Update Badge
    self.updateUnreadMessagesButton(count)
  }
  
  // MARK: - Messaging Screen Segue
  
  /// Will show Messaging View Controller
  private func showMessaging(){
    // Storyboard Reference
    var storyboard : UIStoryboard
    // Check if Device is iPad needs to use Presentation Popover Controller
    if UIView.Device.IS_IPAD {
      // Get Storyboard
      storyboard = UIStoryboard(name: "iPad", bundle: nil)
    } else {
      // Get Storyboard
      storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    // Get Main View Controller
    let conversationViewController = storyboard.instantiateViewController(withIdentifier:"ConversationViewController") as? ConversationViewController
    // Get Navigation Controller
    let navigationController = self.window?.rootViewController as! UINavigationController
    // Push MessagingView to Navigation Controller
    navigationController.pushViewController(conversationViewController!, animated: true)
  }
  
  // MARK: - Notification Counter
  
  /// Will Update Unread Notification Counter on UIFloating Action
  ///
  /// - Parameter count: Unread Notification Counter
  func updateUnreadMessagesButton(_ count: Int) {
    // Get FloatingAction
    if let badge = self.window?.viewWithTag(587777) as? FloatingAction {
      // Set Notification Counter
      badge.setCounterWithInt(count)
    }
  }
}

