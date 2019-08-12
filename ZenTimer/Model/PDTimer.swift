//
//  PDTimer.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/10/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import Foundation

class PDTimer {
    
    // MARK: - Properties
    
    var resetButtonState: ResetButtonState
    var settingsMenuState: SettingsMenuState
    var audioSettingsState: AudioSettingsState
    var workLength: TimeInterval
    var breakLength: TimeInterval
    var timer: Timer
    var duration: TimeInterval
    var timeRemaining: TimeInterval
    var timerState: TimerState
    var workState: WorkState
    var timerMessage: String
    var timerMessageState: TimerMessageState
    var startButtonMessage: String
    
    init(resetButtonState: ResetButtonState, settingsMenuState: SettingsMenuState, audioSettingsState: AudioSettingsState, workLength: TimeInterval, breakLength: TimeInterval, timer: Timer, duration: TimeInterval, timeRemaining: TimeInterval, timerState: TimerState, workState: WorkState, timerMessage: String, timerMessageState: TimerMessageState, startButtonMessage: String) {
        self.resetButtonState = resetButtonState
        self.settingsMenuState = settingsMenuState
        self.audioSettingsState = audioSettingsState
        self.workLength = workLength
        self.breakLength = breakLength
        self.timer = timer
        self.duration = duration
        self.timeRemaining = timeRemaining
        self.timerState = timerState
        self.workState = workState
        self.timerMessage = timerMessage
        self.timerMessageState = timerMessageState
        self.startButtonMessage = startButtonMessage
    }
}
