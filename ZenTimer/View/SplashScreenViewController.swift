//
//  SplashScreenViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/24/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logoLabel.layer.opacity = 0
        topContainerView.layer.opacity = 0
        overlayImageView.layer.opacity = 0
        timerLabel.layer.opacity = 0
        timerMessage.layer.opacity = 0
        startButton.layer.opacity = 0
        statusBarView.layer.opacity = 0
        overlayImageView.layer.compositingFilter = "overlayBlendMode"
        setupAudio()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //add logic to go straight to onboarding instead of ... loading animation twice during onboarding flow
        super.viewWillAppear(true)
        animateLogo {
//            if self.onboardingPresented == false || self.onboardingPresented == true {
            if self.onboardingPresented == false {
                self.performSegue(withIdentifier: "toOnboarding", sender: nil)
                //Consider calling this at the end of onboarding when button is tapped.
                UserDefaults.standard.set(true, forKey: "onboardingPresented")
            } else {
                self.animateViews {
                    self.performSegue(withIdentifier: "toMainStoryboard", sender: nil)
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    func animateLogo(completionHandler: @escaping () -> Void) {
        whiteNoisePlayer.prepareToPlay()
        whiteNoisePlayer.play()
        UIView.animate(withDuration: 0.75, animations: {
            self.logoLabel.layer.opacity = 1
        }) { (_) in
            UIView.animate(withDuration: 0.75, delay: 2.25, animations: {
                self.logoLabel.layer.opacity = 0
            }, completion: { (_) in
                completionHandler()
            })
        }
    }
    
    func animateViews(completionHandler: @escaping () -> Void) {
        whiteNoisePlayer.prepareToPlay()
        whiteNoisePlayer.play()
        self.statusBarHidden = false
        UIView.animate(withDuration: 02.25, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
        UIView.animate(withDuration: 2.25, animations: {
            self.timerLabel.layer.opacity = 1
            self.overlayImageView.layer.opacity = 0.6
            self.topContainerView.layer.opacity = 1
            self.statusBarView.layer.opacity = 1
        }, completion: { (_) in
            completionHandler()
        })
    }
    
    func setupAudio() {
        if let whiteNoiseFilePath = Bundle.main.path(forResource: "whiteNoise_transition", ofType: "wav") {
            let url = URL(fileURLWithPath: whiteNoiseFilePath)
            do {
                whiteNoisePlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        whiteNoisePlayer.volume = 2
        whiteNoisePlayer.numberOfLoops = 0
    }
    
    @IBOutlet weak var timerMessage: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var statusBarHidden = true
    var logoSoundPlayer = AVAudioPlayer()
    var whiteNoisePlayer = AVAudioPlayer()
    var onboardingPresented = UserDefaults.standard.bool(forKey: "onboardingPresented")
}
