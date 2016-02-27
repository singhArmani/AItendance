//
//  AppDelegate.swift
//  SampleBeaconCheckIn
//
//  Created by simranjeet on 14/02/2016.
//  Copyright © 2016 singh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //MARK: - SDK Options
        
        BlueCatsSDK.setOptions([BCOptionShowBluetoothPowerWarningMessage:"YES"]) // warning if bluetooth is not turned ON
        
        //MARK: - startPurringWith
        BlueCatsSDK.startPurringWithAppToken("41f89c47-60fd-4264-8578-6a6088518f0e", completion: {(BCStatus) -> Void in
            //closure body
            let appTokenVarificationStatus = BlueCatsSDK.appTokenVerificationStatus()
            
            //if there's no app token provided or it's invalid
            if(appTokenVarificationStatus == .NotProvided || appTokenVarificationStatus == .Invalid)
            {
                
                print("get app token from https://app.bluecats.com")
            }
            
            //if not allowed authorization, then allow beacon ranging when the app is not in use
            if(!BlueCatsSDK.isLocationAuthorized()){
                
                BlueCatsSDK.requestAlwaysLocationAuthorization()
                //BlueCatsSDK.requestWhenInUseLocationAuthorization()
            }
            
            if(!BlueCatsSDK.isBluetoothEnabled())
            {
                BlueCatsSDK.setOptions([BCOptionShowBluetoothPowerWarningMessage:"YES"]) // warning if bluetooth is not turned ON
                
            }
            
            
        })
        
        
        
        
        //Register user notification settings in your app delegate.
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil))
        
        
        
        
        
        return true
    }
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

