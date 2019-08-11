//
//  PDTimerViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/8/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - Views
    
    func setupUI(){
        settingsView.alpha = 0
        overlayView.layer.compositingFilter = "overlayBlendMode"
        if pdTimer.audioSettingsState == .soundOff {
            muteButton.alpha = 100
        } else if pdTimer.audioSettingsState == .soundOn {
            muteButton.alpha = 0.25
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func muteButtonTapped(_ sender: Any) {
        if pdTimer.audioSettingsState == .soundOn {
            pdTimer.audioSettingsState = .soundOff
            muteButton.alpha = 100
        } else if pdTimer.audioSettingsState == .soundOff {
            pdTimer.audioSettingsState = .soundOn
            muteButton.alpha = 0.25
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        if pdTimer.settingsMenuState == .open {
            pdTimer.settingsMenuState = .closed
            //Show and enable buttons/labels in Top Container
            for button in topContainerButtons {
                button.isEnabled = true
                button.isHidden = false
            }
            for label in topContainerLabels {
                label.isHidden = false
            }
            //Hide SettingsView and 'grey out' button
            settingsButton.alpha = 0.25
            settingsView.alpha = 0
        } else if pdTimer.settingsMenuState == .closed {
            pdTimer.settingsMenuState = .open
            //Hide and disable buttons/labels in Top Container
            for button in topContainerButtons {
                button.isEnabled = false
                button.isHidden = true
            }
            for label in topContainerLabels {
                label.isHidden = true
            }
            //Show SettingsView and highlight button
            settingsButton.alpha = 100
            settingsView.alpha = 100
        }
    }
    
    @IBAction func decreaseBreakLengthTapped(_ sender: Any) {
        if pdTimer.breakLength > 0 {
            pdTimer.breakLength -= 1
            breakLengthLabel.text = String(Int(pdTimer.breakLength))
            messageLabel.text = ""
        }
    }
    
    @IBAction func increaseBreakLengthTapped(_ sender: Any) {
        pdTimer.breakLength += 1
        breakLengthLabel.text = String(Int(pdTimer.breakLength))
        messageLabel.text = ""
    }
    
    @IBAction func decreaseSessionLengthTapped(_ sender: Any) {
        if pdTimer.workLength > 0 {
            pdTimer.workLength -= 1
            sessionLengthLabel.text = String(Int(pdTimer.workLength))
            //Fix later to reflect Int as timer
            timerLabel.text = "\(Int(pdTimer.workLength)):00"
            messageLabel.text = ""
        }
    }
    
    @IBAction func increaseSessionLengthTapped(_ sender: Any) {
        pdTimer.workLength += 1
        sessionLengthLabel.text = String(Int(pdTimer.workLength))
        //Fix later to reflect Int as timer
        timerLabel.text = "\(Int(pdTimer.workLength)):00"
        messageLabel.text = ""
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - IBObjects
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var breakLengthLabel: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet var topContainerButtons: [UIButton]!
    @IBOutlet var topContainerLabels: [UILabel]!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    let pdTimer = PDTimer()
}
