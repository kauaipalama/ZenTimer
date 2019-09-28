//
//  AppDelegate.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/7/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Removed notificationCenter instance var

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let onboardingPresented = UserDefaults.standard.bool(forKey: "onboardingPresented")
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let splashScreenStoryboard = UIStoryboard(name: "SplashScreen", bundle: nil)
        var initialViewController: UIViewController?
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if onboardingPresented == false {
            initialViewController = onboardingStoryboard.instantiateViewController(withIdentifier: "onboarding")
        } else {
            initialViewController = splashScreenStoryboard.instantiateViewController(withIdentifier: "splashScreen")
        }
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

