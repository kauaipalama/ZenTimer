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
                //Also. Why the delay? Investigate. Spaghetti code.
                //Conculsion: There is a contradiction between the ReviewController and this AlarmNotificationDelegate logic. In the ReviewController the presentation is delayed only when sound is on. In this file it is delayed when sound is off.
                //FIX: Go into ReviewController file and call Dispatch for delay in both cases, removing logic. Simplifying code.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //Check for interstitial ad eligibility when app returns from .background state with sound off
                    ReviewController.shared.requestReview()
                }
            } else if PDTimerController.shared.pdTimer.audioSettingsState == .soundOn {
                //Check for interstitial ad eligibility when app returns from .background state with sound on
                ReviewController.shared.requestReview()
            }
        }
    }
}
