//
//  ReviewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 4/14/20.
//  Copyright © 2020 Kainoa Palama. All rights reserved.
//

import Foundation
import StoreKit

class ReviewController {
    fileprivate init() {}
    
    static let shared = ReviewController()
    
    func requestReview() {
        if PDTimerController.shared.pdTimer.audioSettingsState == .soundOff {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
        } else if PDTimerController.shared.pdTimer.audioSettingsState == .soundOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SKStoreReviewController.requestReview()
            }
        }
    }
}
