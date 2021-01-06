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
    
    private var oneHundredTwentyThreeDaysLater: Date {
        return Calendar.current.date(byAdding: .day, value: -365, to: Date())!
    }
    
    private var shouldRequestReview: Bool {
        if initialLaunch == nil {
            initialLaunch = Date()
            return false
        } else if let initialLaunch = self.initialLaunch, initialLaunch < oneWeekAgo && numberOfRequests < 1 {
            numberOfRequests += 1
            return true
        } else if let initialLaunch = self.initialLaunch, initialLaunch < oneHundredTwentyThreeDaysLater && numberOfRequests < 2 {
            numberOfRequests += 1
            return true
        }
        return false
    }
    
    func requestReview() {
        guard  shouldRequestReview else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SKStoreReviewController.requestReview()
        }
    }
}
