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

class PDTimerController {
    
    // MARK: - Initializer
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - Timer Functions
    
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
            //Messages switching on timerState
            if pdTimer.timerState == .ready {
                pdTimer.timerMessage = "Ready to Work. I love my job!"
            } else if pdTimer.timerState == .running {
                pdTimer.timerMessage = "Working hard. Hardly Working"
            } else if pdTimer.timerState == .finished {
                pdTimer.timerMessage = "Finished Working. Thank goodness!"
//                toggleWorkState()
            }
        } else if pdTimer.workState == .onBreak {
            //Messages switching on timerState
            if pdTimer.timerState == .ready {
                pdTimer.timerMessage = "Ready for a Break!"
            } else if pdTimer.timerState == .running {
                pdTimer.timerMessage = "On Break. My boss is so generous!"
            } else if pdTimer.timerState == .finished {
                pdTimer.timerMessage = "Finished Break. I love my job!"
//                toggleWorkState()
            }
        }
    }
    
    func toggleWorkState() {
        if pdTimer.workState == .onBreak {
            pdTimer.workState = .working
        } else if pdTimer.workState == .working {
            pdTimer.workState = .onBreak
        }
    }
    
    func toggleStartButtonLabelMessage(completion: (() -> Void)?) {
        if pdTimer.timerState == .ready || pdTimer.timerState == .finished || pdTimer.timerState == .stopped {
            pdTimer.startButtonMessage = "TAP TO START"
        } else if pdTimer.timerState == .running {
            pdTimer.startButtonMessage = "TAP TO PAUSE"
        }
        completion?()
    }
    func checkTimer(completion: () -> Void) {
        if pdTimer.timerState == .running && pdTimer.workState == .working && (pdTimer.duration * 60 == pdTimer.workLength || pdTimer.timeRemaining == 0) {
            fireAlarm {
                print("Alarm closure switching to onBreak")
                pdTimer.timerState = .ready
            }
        } else if pdTimer.timerState == .running && pdTimer.workState == .onBreak && (pdTimer.duration * 60 == pdTimer.breakLength || pdTimer.timeRemaining == 0) {
            fireAlarm {
                print("Alarm closure switching to working")
                pdTimer.timerState = .ready
            }
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
    
    func fireAlarm(completion: () -> Void) {
        setTimeRemaining()
        pdTimer.timer.invalidate()
        pdTimer.duration = 0
        pdTimer.timerState = .finished
        toggleMessage()
        //Might need a closure in this function as well to reset the text of the VC when done. USe same non-returning clousre method. Maybe make closure optional.
        toggleStartButtonLabelMessage(completion: nil)
        print("Alarm alarm alarm!")
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        print("Saved")
    }
    
    func loadFromPersistentStore() {
        print("Loaded")
    }
    
    // MARK: - Properties
    
    static let shared = PDTimerController()
    var pdTimer = PDTimer(resetButtonState: .notTapped,settingsMenuState: .closed, audioSettingsState: .soundOn, workLength: 25, breakLength: 5, timer: Timer(), duration: 0, timeRemaining: 0, timerState: .ready, workState: .working, timerMessage: "", timerMessageState: .readyMessage, startButtonMessage: "TAP TO START")
}
