//
//  PDTimerViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/8/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

//BUG: Time remaining seems to be not updating judging by the label. COunt goes negative and start buttton loses proper functionality. It doubles the speed of the countdown every other press. LIGHT AT THE END OF THE TUNNEL BOYS!
import UIKit

class TimerViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - Views
    
    func setupUI(){
        resetView.alpha = 0
        settingsView.alpha = 0
        overlayView.layer.compositingFilter = "overlayBlendMode"
        if pdTimer.audioSettingsState == .soundOff {
            muteButton.alpha = 100
        } else if pdTimer.audioSettingsState == .soundOn {
            muteButton.alpha = 0.25
        }
        pdTimer.timerState = .ready
        PDTimerController.shared.setTimeRemaining()
        timerLabel.text = String(Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining))
        PDTimerController.shared.toggleMessage()
        messageLabel.text = pdTimer.timerMessage
    }
    

    // MARK: - IBActions
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        if pdTimer.resetButtonState == .notTapped {
            pdTimer.resetButtonState = .tapped
            for button in topContainerButtons {
                button.isEnabled = false
                button.isHidden = true
            }
            for label in topContainerLabels {
                label.isHidden = true
            }
            resetButton.alpha = 100
            resetView.alpha = 100
        } else if pdTimer.resetButtonState == .tapped {
            pdTimer.resetButtonState = .notTapped
            for button in topContainerButtons {
                button.isEnabled = true
                button.isHidden = false
            }
            for label in topContainerLabels {
                label.isHidden = false
            }
            resetButton.alpha = 0.25
            resetView.alpha = 0
        }
    }
    
    
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
        }
    }
    
    @IBAction func increaseBreakLengthTapped(_ sender: Any) {
        pdTimer.breakLength += 1
        breakLengthLabel.text = String(Int(pdTimer.breakLength))
    }
    
    @IBAction func decreaseSessionLengthTapped(_ sender: Any) {
        if pdTimer.workLength > 0 {
            pdTimer.workLength -= 1
            sessionLengthLabel.text = String(Int(pdTimer.workLength))
            timerLabel.text = "\(Int(pdTimer.workLength)):00"
        }
    }
    
    @IBAction func increaseSessionLengthTapped(_ sender: Any) {
        pdTimer.workLength += 1
        sessionLengthLabel.text = String(Int(pdTimer.workLength))
        timerLabel.text = "\(Int(pdTimer.workLength)):00"
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        PDTimerController.shared.toggleMessage()
        if pdTimer.timerState == .ready {
            pdTimer.timerState = .running
            PDTimerController.shared.toggleStartButtonLabelMessage {
                self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            //Need a reusable start timer func
            pdTimer.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                PDTimerController.shared.pdTimer.duration += 1
                PDTimerController.shared.setTimeRemaining()
                PDTimerController.shared.checkTimer(completion: {
                    self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                })
                self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
                PDTimerController.shared.toggleMessage()
                self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
            })
        } else if pdTimer.timerState == .running  {
            PDTimerController.shared.stop()
            pdTimer.timerState = .stopped
            PDTimerController.shared.toggleStartButtonLabelMessage {
                self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
        } else if pdTimer.timerState == .stopped {
            pdTimer.timerState = .running
            PDTimerController.shared.toggleStartButtonLabelMessage {
                self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            //Need a reusable start timer func
            pdTimer.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                PDTimerController.shared.pdTimer.duration += 1
                PDTimerController.shared.setTimeRemaining()
                PDTimerController.shared.checkTimer(completion: {
                    self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                })
                self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
                PDTimerController.shared.toggleMessage()
                self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
            })
        } else if pdTimer.timerState == .finished {
            PDTimerController.shared.toggleWorkState()
            pdTimer.timerState = .running
            //If it is finished. Ready it again and
            PDTimerController.shared.setTimeRemaining()
            timerLabel.text = String(Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining))
//            pdTimer.timerState = .running
            PDTimerController.shared.toggleStartButtonLabelMessage {
                self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            pdTimer.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                PDTimerController.shared.pdTimer.duration += 1
                PDTimerController.shared.setTimeRemaining()
                PDTimerController.shared.checkTimer(completion: {
                    self.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                })
                self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
                PDTimerController.shared.toggleMessage()
                self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
            })
        }
        PDTimerController.shared.toggleMessage()
        self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
    }
    
    // MARK: - IBObjects
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var breakLengthLabel: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet var topContainerButtons: [UIButton]!
    @IBOutlet var topContainerLabels: [UILabel]!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    let pdTimer = PDTimerController.shared.pdTimer
}
