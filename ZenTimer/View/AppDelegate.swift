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
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

