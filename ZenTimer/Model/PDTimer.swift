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
    
    var workLength: TimeInterval = 25
    var breakLength: TimeInterval = 5
    var timer = Timer()
    var duration = 0
    var displayedTime: TimeInterval = 0
    var timerState: TimerState = .ready
    var workState: WorkState = .working
    var message = ""
    var messageState: MessageState = .readyMessage
    var settingsMenuState: SettingsMenuState = .closed
    var audioSettingsState: AudioSettingsState = .soundOn
}
