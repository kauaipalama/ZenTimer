//
//  DoubleExtension.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/10/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import Foundation

extension Double {
    func secondsToMinutesAndSeconds(timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        if let formattedString = formatter.string(from: timeInterval) {
            return formattedString
        } else {
            return "😭"
        }
    }
}
