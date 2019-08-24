//
//  PDTimerController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/10/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

/*
timerMessage is not updating properly. Need to
 */

import Foundation
import UserNotifications

class PDTimerController {
    
    // MARK: - Initializer
    
    init() {
    }
    
    // MARK: - UI Functionality
    
    func setTimeRemaining() {
        if pdTimer.workState == .working {
            //RESET 30 to 60 to make accurate. TEST PURPOSES ONLY
            pdTimer.timeRemaining = pdTimer.workLength * 60 - pdTimer.duration
        } else if pdTimer.workState == .onBreak {
            pdTimer.timeRemaining = pdTimer.breakLength * 60 - pdTimer.duration
        }
    }
    
    func convertTimeRemainingToString(timeRemaining: TimeInterval) -> String {
        return Double().secondsToMinutesAndSeconds(timeInterval: timeRemaining)
    }
    
    func toggleMessage() {
        if pdTimer.workState == .working {
            if pdTimer.timerState == .ready {
                pdTimer.timerMessage = "Ready to Work. I love my job!"
            } else if pdTimer.timerState == .running {
                pdTimer.timerMessage = "Working hard. Hardly Working"
            } else if pdTimer.timerState == .finished {
                pdTimer.timerMessage = "Finished Working. Thank goodness!"
            }
        } else if pdTimer.workState == .onBreak {
            if pdTimer.timerState == .ready {
                pdTimer.timerMessage = "Ready for a Break!"
            } else if pdTimer.timerState == .running {
                pdTimer.timerMessage = "On Break. My boss is so generous!"
            } else if pdTimer.timerState == .finished {
                pdTimer.timerMessage = "Finished Break. I love my job!"
            }
        }
    }
    
    
    func toggleStartButtonLabelMessage(completion: () -> Void) {
        if pdTimer.timerState == .ready || pdTimer.timerState == .finished || pdTimer.timerState == .stopped {
            pdTimer.startButtonMessage = "TAP TO START"
        } else if pdTimer.timerState == .running {
            pdTimer.startButtonMessage = "TAP TO PAUSE"
        }
        completion()
    }
    
    // MARK: - Timer Functionality
    
    func toggleWorkState() {
        if pdTimer.workState == .onBreak {
            pdTimer.workState = .working
        } else if pdTimer.workState == .working {
            pdTimer.workState = .onBreak
        }
    }
    
    func checkTimer(completion: () -> Void) {
        if pdTimer.timerState == .running && pdTimer.workState == .working && (pdTimer.duration == pdTimer.workLength * 60 || pdTimer.timeRemaining == 0) {
            fireAlarm()
        } else if pdTimer.timerState == .running && pdTimer.workState == .onBreak && (pdTimer.duration == pdTimer.breakLength * 60 || pdTimer.timeRemaining == 0) {
            fireAlarm()
        }
        completion()
    }
    
    func stop() {
        if pdTimer.duration < pdTimer.workLength * 60 || pdTimer.duration < pdTimer.breakLength * 60 {
            setTimeRemaining()
            pdTimer.timer.invalidate()
            pdTimer.timerState = .stopped
        }
    }
    
    func fireAlarm() {
        setTimeRemaining()
        pdTimer.timer.invalidate()
        pdTimer.duration = 0
        pdTimer.timerState = .finished
        toggleMessage()
        print("Alarm alarm alarm!")
    }
    
    func reset() {
        pdTimer.timer.invalidate()
        pdTimer.duration = 0
        pdTimer.timerState = .ready
        toggleMessage()
        setTimeRemaining()
    }
    
    // MARK: - Local Notifications
    
    func scheduleAlarmNotification() {
        let content = UNMutableNotificationContent()
        var bodyString: String  {
            var string = ""
            if pdTimer.workState == .working {
                string = "Time for a break!"
            } else if pdTimer.workState == .onBreak {
                string = "Break time's over!"
            }
            return string
        }
        content.title = "Alarm"
        content.body = bodyString
        content.sound = UNNotificationSound(named: UNNotificationSoundName("glass_DoneLoud.wav"))
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = "localNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        soundOn.toggle()
        defaults.set(soundOn, forKey: "AudioSettings")
    }
    
    func loadFromPersistentStore() {
        soundOn = defaults.object(forKey: "AudioSettings") as? Bool ?? true
        if soundOn == true {
            pdTimer.audioSettingsState = .soundOn
        } else if soundOn == false {
            pdTimer.audioSettingsState = .soundOff
        }
    }
    
    // MARK: - Properties
    
    static let shared = PDTimerController()
    let defaults = UserDefaults.standard
    let notificationCenter = UNUserNotificationCenter.current()
    var soundOn = true
    var pdTimer = PDTimer(resetButtonState: .notTapped,settingsMenuState: .closed, audioSettingsState: .soundOn, workLength: 25, breakLength: 5, timer: Timer(), duration: 0, timeRemaining: 0, timerState: .ready, workState: .working, timerMessage: "", timerMessageState: .readyMessage, startButtonMessage: "TAP TO START")
}
