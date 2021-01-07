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
    private init() {}
    
    static let shared = ReviewController()
    
    private var initialLaunch: Date? {
        get {
            return UserDefaults.standard.value(forKey: "initialLaunch") as? Date
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "initialLaunch")
        }
    }
    
    private var numberOfRequests: Int {
        get {
            return UserDefaults.standard.integer(forKey: "numberOfRequests")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "numberOfRequests")
        }
    }
    
    private var oneWeekAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }
    
    private var oneHundredTwentyThreeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -14, to: Date())!
    }
    
    private var eligibleForReviewRequest: Bool {
        if initialLaunch == nil {
            initialLaunch = Date()
            return false
        } else if let initialLaunch = self.initialLaunch, initialLaunch < oneWeekAgo && numberOfRequests < 1 {
            numberOfRequests += 1
            return true
        } else if let initialLaunch = self.initialLaunch, initialLaunch < oneHundredTwentyThreeDaysAgo && numberOfRequests < 2 {
            numberOfRequests += 1
            return true
        }
        return false
    }
    
    var reviewInProgress: Bool = false
    
    func requestReview() {
        guard eligibleForReviewRequest == true else {return}
        guard PDTimerController.shared.pdTimer.workState == .working else {return}
        reviewInProgress = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            SKStoreReviewController.requestReview()
            UIApplication.shared.endIgnoringInteractionEvents()
            reviewInProgress = false
        }
    }
}
