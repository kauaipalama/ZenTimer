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
            messageLabel.text = ""
        }
    }
    
    @IBAction func increaseBreakLengthTapped(_ sender: Any) {
        breakLength += 1
        breakLengthLabel.text = String(breakLength)
        messageLabel.text = ""
    }
    
    @IBAction func decreaseSessionLengthTapped(_ sender: Any) {
        if sessionLength > 0 {
            sessionLength -= 1
            sessionLengthLabel.text = String(sessionLength)
            //Fix later to reflect Int as timer
            timerLabel.text = "\(sessionLength):00"
            messageLabel.text = ""
        }
    }
    
    @IBAction func increaseSessionLengthTapped(_ sender: Any) {
        sessionLength += 1
        sessionLengthLabel.text = String(sessionLength)
        //Fix later to reflect Int as timer
        timerLabel.text = "\(sessionLength):00"
        messageLabel.text = ""
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if timerIsOn == false {
            //Hide and Disable buttons in Top Container when timer Starts
            for button in topContainerButtons {
                button.isEnabled = false
                button.alpha = 0
            }
            //Start Timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.time += 1
                self.timerLabel.text = String((self.sessionLength * 60) - self.time)
                //TEST: To Change state from session to break
                if self.timerLabel.text == "0" && self.time < 0 && self.isOnBreak == false {
                    self.isOnBreak = true
                    self.messageLabel.text = "take a break"
                    print("isOnBreak: \(self.isOnBreak)")
                } else if self.timerLabel.text == "0" && self.time < 0 && self.isOnBreak == true {
                    self.isOnBreak = false
                    self.messageLabel.text = "break time is over"
                    print("isOnBreak: \(self.isOnBreak)")
                }
                if self.isOnBreak == false {
                    self.messageLabel.text = "until your next break"
                    if self.time == (self.sessionLength * 60) {
                        self.timer.invalidate()
                        self.timerIsOn = false
                        self.time = 0
                        if self.isOnBreak == false {
                            self.messageLabel.text = "it's time for a break"
                        }
                        self.timerLabel.text = "\(self.sessionLength):00"
                        for button in self.topContainerButtons {
                            button.alpha = 100
                            button.isEnabled = true
                        }
                        self.startButton.setTitle("TAP TO PAUSE", for: .normal)
                    }
                } else if self.isOnBreak == true {
                    self.messageLabel.text = "Take a break"
                    if self.time == (self.breakLength * 60) {
                        self.timer.invalidate()
                        self.timerIsOn = false
                        self.time = 0
                        if self.isOnBreak == true {
                            self.messageLabel.text = "break time is over"
                            self.timerLabel.text = "\(self.breakLength):00"
                        }
                        for button in self.topContainerButtons {
                            button.alpha = 100
                            button.isEnabled = true
                        }
                        self.startButton.setTitle("TAP TO START", for: .normal)
                    }
                }
            })
            timerIsOn = true
            startButton.setTitle("TAP TO PAUSE", for: .normal)
        } else {
            //Stop Timer
            timer.invalidate()
            //Show and Enable buttons in Top Container when timer Ends
            for button in topContainerButtons {
                button.isEnabled = true
                button.alpha = 0
            }
            timerLabel.text = String((self.sessionLength * 60) - self.time)
            timerIsOn = false
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
    var isOnBreak = false
    var settingsMenuOpen = false
    var timer = Timer()
    var time = 0
    var timerIsOn = false
    
}
