//
//  AdController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 12/19/20.
//  Copyright © 2020 Kainoa Palama. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdController: NSObject, GADInterstitialDelegate {
    
    private override init() {}
    static let shared = AdController()
    private var interstitial: GADInterstitial!
    
    func initializeInterstitalAd() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func presentInterstitialAd(rootViewController: UIViewController) {
        guard ReviewController.shared.reviewInProgress == false else {return}
        guard PDTimerController.shared.pdTimer.workState == .working else {return}
        if interstitial.isReady {
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                interstitial.present(fromRootViewController: rootViewController)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        initializeInterstitalAd()
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
