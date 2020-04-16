//
//  AlarmNotificationDelegate.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 4/15/20.
//  Copyright © 2020 Kainoa Palama. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            if PDTimerController.shared.pdTimer.audioSettingsState == .soundOff {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ReviewController.shared.requestReview()
                }
            } else if PDTimerController.shared.pdTimer.audioSettingsState == .soundOn {
                ReviewController.shared.requestReview()
            }
        }
    }
}
