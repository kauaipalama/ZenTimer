//
//  States.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/10/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import Foundation

enum WorkState {
    case working
    case onBreak
}

enum TimerState {
    case ready
    case running
    case finished
}

enum MessageState {
    case readyMessage
    case runningMessage
    case finishedMessage
}

enum SettingsMenuState {
    case open
    case closed
}

enum AudioSettingsState {
    case soundOn
    case soundOff
}
