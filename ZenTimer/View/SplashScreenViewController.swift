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
        setupViews()
        setupAudio()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animateLogo {
            self.whiteNoisePlayer.prepareToPlay()
            self.whiteNoisePlayer.play()
            self.performSegue(withIdentifier: "toMainStoryboard", sender: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    func setupViews() {
        logoLabel.layer.opacity = 0
        logoLabel.text = Constants.quartzLogo
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
    
    @IBOutlet weak var logoLabel: UILabel!
    
    var statusBarHidden = true
    var logoSoundPlayer: AVAudioPlayer!
    var whiteNoisePlayer: AVAudioPlayer!
    var onboardingPresented = UserDefaults.standard.bool(forKey: "onboardingPresented")
}
