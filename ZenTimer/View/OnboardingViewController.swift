//
//  OnboardingViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 9/17/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.layer.opacity = 0
        onboardingView.layer.opacity = 0
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.4) {
            self.skipButton.layer.opacity = 1
            self.onboardingView.layer.opacity = 1
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func onboardingItemsCount() -> Int {
        return 7
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if onboardingView.currentIndex == 5 && index == 4 {
            UIView.animate(withDuration: 0.2, animations: {
                self.skipButton.layer.opacity = 1
            }) { (_) in
                self.skipButton.isEnabled = true
            }
        }
        
        if index == 5 {
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.skipButton.layer.opacity = 0
            }) { (_) in
                self.skipButton.isEnabled = false
            }
        }
        
        if index == 6 {
            UIView.animate(withDuration: 0.4, animations: {
                self.onboardingView.layer.opacity = 0
                self.skipButton.layer.opacity = 0
            }) { (_) in
                UserDefaults.standard.set(true, forKey: "onboardingPresented")
                self.performSegue(withIdentifier: "toSplashScreen", sender: nil)
            }
        }
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColor = UIColor(red: 89.0/255.0, green: 213.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .medium)
        let descriptionFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        return [OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                                   title: "Thank you for purchasing Quartz: Timer",
                                   description: "Divide a task into managable chunks, seperated by short breaks. Increase productivity, reduce stress, get better results. Modeled after the 'Pomodoro Technique'.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "customTimer")!,
                                   title: "Custom Break/Session Lengths",
                                   description: "We recommend a session length of 25 minutes and a break length of 5 minutes. After 3 or 4 sessions, consider increasing break length to 15-20 minutes for one round.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "audioWave")!,
                                   title: "White Noise",
                                   description: "Sounds of wind and sea, beautifully mixed. Designed to reduce background noise while instilling a sense of calm and serenity.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "lock")!,
                                   title: "Runs from Lock Screen",
                                   description: "Runs in the background without interruptions. Automatically adjusts volume for phone calls, notifications and audio from other applications.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "notification")!,
                                   title: "Notifications",
                                   description: "Receive a notification upon timer completion, when the application is running in the background.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                                   title: "Swipe to Begin >>>",
                                   description: "If you enjoy Quartz: Timer, feel free to leave us a review in the App Store! Thank you.",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(),
                                   title: "",
                                   description: "",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont)][index]
    }
    
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var onboardingView: PaperOnboarding!
}
