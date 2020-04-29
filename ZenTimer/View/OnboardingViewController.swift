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
        let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        let descriptionFont = UIFont.preferredFont(forTextStyle: .body)
        return [OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                                   title: Constants.onboardingSlide1Title,
                                   description: Constants.onboardingSlide1Description,
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "customTimer")!,
                                   title: Constants.onboardingSlide2Title,
                                   description: Constants.onboardingSlide2Description,
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "audioWave")!,
                                   title: Constants.onboardingSlide3Title,
                                   description: Constants.onboardingSlide3Description,
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "lock")!,
                                   title: Constants.onboardingSlide4Title,
                                   description: Constants.onboardingSlide4Description,
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "notification")!,
                                   title: Constants.onboardingSlide5Title,
                                   description: Constants.onboardingSlide5Description,
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont,
                                   descriptionFont: descriptionFont),
                OnboardingItemInfo(informationImage: UIImage(named: "logo")!,
                                   title: Constants.onboardingSlide6Title,
                                   description: Constants.onboardingSlide6Description,
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
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.onboardingView.layer.opacity = 0
            self.skipButton.layer.opacity = 0
        }) { (_) in
            UserDefaults.standard.set(true, forKey: "onboardingPresented")
            self.performSegue(withIdentifier: "toSplashScreen", sender: nil)
        }
    }
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var onboardingView: PaperOnboarding!
}
