//
//  AppDelegate.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import Crashlytics
import Fabric
import UserNotifications
/**
This class is supposed to be there to handle application lifecycle events - i.e., responding to the app being launched, backgrounded, foregrounded, receiving data, and so on.
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: Variable
    /**
     The backdrop for your app’s user interface and the object that dispatches events to your views.
   */
    var window: UIWindow?
    
    //MARK: Life cycle of AppDelegate
    
     /**
     Tells the delegate that the launch process is almost done and the app is almost ready to run.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Utility.registerForRemoteNotifications()
        /**
         call method of dispaly badge count number on app icon
        */
        Utility.setBadgeCountOnAppIcon(badgeNumber: 0)
       /**
         call setup method of Fabric.
         */
       // Fabric.with([Crashlytics.self])
        
        return true
    }

    /**
    Tells the delegate that the app is about to become inactive.
    */
    func applicationWillResignActive(_ application: UIApplication) {
       // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
     /**
    Tells the delegate that the app is now in the background.
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    /**
    Tells the delegate that the app is about to enter the foreground.
    */
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    /**
    Tells the delegate that the app has become active.
    */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    /**
    Tells the delegate when the app is about to terminate.
    */
    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
     Tells the delegate that events related to a URL session are waiting to be processed.
     */
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
        completionHandler()
    }
    
    
    //MARK:- basic setup of push notification
    /**
     basic setup of push notification
    */
    
    func setupPushNotification(forApplication app: UIApplication){
        if #available(iOS 10.0, *) {
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            app.registerUserNotificationSettings(settings)
        }
        app.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /**
    Tells the delegate that the app successfully registered with Apple Push Notification service (APNs).
    */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Print it to console
        UserDefaults.standard.set(deviceTokenString, forKey: kWSDEVICETOKENPARAM)
    }
    
    /** Called when APNs failed to register the device for push notifications
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    /**
     Tells the app that a remote notification arrived that indicates there is data to be fetched.
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       print("call next method")
    }

    /**
     Asks the delegate to open a resource identified by a URL.
     */
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return true
    }
}

//MARK:- create extension of UNUserNotificationCenterDelegate
/**
 create extension of UNUserNotificationCenterDelegate
 */

extension AppDelegate : UNUserNotificationCenterDelegate{
    
    //MARK:- Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
    /**
     Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
}

