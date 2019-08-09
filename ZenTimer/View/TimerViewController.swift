//
//  TimerViewController.swift
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
        
        if isMuted == false {
            muteButton.alpha = 0.25
        } else {
            muteButton.alpha = 100
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func muteButtonTapped(_ sender: Any) {
        if isMuted == true {
            isMuted = false
            muteButton.alpha = 0.25
        } else {
            isMuted = true
            muteButton.alpha = 100
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        if settingsMenuOpen == true {
            settingsMenuOpen = false
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
        } else {
            settingsMenuOpen = true
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
        if breakLength > 0 {
            breakLength -= 1
            breakLengthLabel.text = String(breakLength)
        }
    }
    
    @IBAction func increaseBreakLengthTapped(_ sender: Any) {
        breakLength += 1
        breakLengthLabel.text = String(breakLength)
    }
    
    @IBAction func decreaseSessionLengthTapped(_ sender: Any) {
        if sessionLength > 0 {
            sessionLength -= 1
            sessionLengthLabel.text = String(sessionLength)
            //Fix later to reflect Int as timer
            timerLabel.text = "\(sessionLength):00"
        }
    }
    
    @IBAction func increaseSessionLengthTapped(_ sender: Any) {
        sessionLength += 1
        sessionLengthLabel.text = String(sessionLength)
        //Fix later to reflect Int as timer
        timerLabel.text = "\(sessionLength):00"
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if timerDidStart == false {
            //Disable buttons in Top Container when timer Starts
            for button in topContainerButtons {
                button.isEnabled = false
            }
            //Start Timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.time += 1
                self.timerLabel.text = String((self.sessionLength * 60) - self.time)
            })
            timerDidStart = true
            startButton.setTitle("TAP TO PAUSE", for: .normal)
        } else {
            //Stop Timer
            timer.invalidate()
            //Enable buttons in Top Container when timer Ends
            for button in topContainerButtons {
                button.isEnabled = true
            }
            timerLabel.text = String((self.sessionLength * 60) - self.time)
            timerDidStart = false
            startButton.setTitle("TAP TO START", for: .normal)
        }
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
    
    
    // MARK: - Parameters
    
    var sessionLength = 25
    var breakLength = 5
    var isMuted = false
    var settingsMenuOpen = false
    var timer = Timer()
    var time = 0
    var timerDidStart = false
    
}
