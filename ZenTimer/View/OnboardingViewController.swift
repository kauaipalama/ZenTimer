//
//  OnboardingViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 9/17/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.opacity = 0
        skipButton.layer.opacity = 0
        pageView.layer.opacity = 0
        doneButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.4) {
            self.doneButton.layer.opacity = 1
            self.skipButton.layer.opacity = 1
            self.pageView.layer.opacity = 1
            self.doneButton.isEnabled = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.pageView.layer.opacity = 0
            self.doneButton.layer.opacity = 0
            self.skipButton.layer.opacity = 0
        }) { (_) in
            self.performSegue(withIdentifier: "toSplashScreen", sender: nil)
        }
    }
    
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pageView: UIView!
}
