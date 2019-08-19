//
//  PDTimerViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/8/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PDTimerController.shared.loadFromPersistentStore()
        setUpAudio()
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
        if pdTimer.audioSettingsState == .soundOff {
            muteButton.alpha = 100
        } else if pdTimer.audioSettingsState == .soundOn {
            muteButton.alpha = 0.25
        }
    }
    
    // MARK: - Private
    
    fileprivate func runTimer() {
        pdTimer.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            PDTimerController.shared.pdTimer.duration += 1
            PDTimerController.shared.setTimeRemaining()
            PDTimerController.shared.checkTimer(completion: { [weak self] in
                PDTimerController.shared.toggleStartButtonLabelMessage(completion: { [weak self] in
                    self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                })
                if self?.pdTimer.timerState == .finished {
                    let alert = UIAlertController(title: "Timer Finished", message: "Love and Gratitude", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(ok)
                    //Fire Sound Here
                    if let topContainerButtons = self?.topContainerButtons {
                        for button in topContainerButtons {
                            button.isEnabled = true
                            button.alpha = 100
                        }
                    }
                    if UIApplication.shared.applicationState != .background {
                        self?.alertSoundPlayer.play()
                    }
                    self?.present(alert, animated: true, completion: {
                        PDTimerController.shared.toggleWorkState()
                        self?.pdTimer.timerState = .ready
                        PDTimerController.shared.toggleMessage()
                        self?.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
                        PDTimerController.shared.setTimeRemaining()
                        self?.timerLabel.text = String(Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining))
                        PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                            self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                        }
                    })
                    //Fire Notification Here if app is in background
                    PDTimerController.shared.scheduleNotification()
                    self?.whiteNoisePlayer.volume = 0

                }
            })
            self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
            PDTimerController.shared.toggleMessage()
            self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
        })
    }
    
    fileprivate func setUpAudio() {
        //Need fade out when timer finished
        //Needs to play white noise one and loop ocean sound for timeRemaining
        //Needs to load audio state whether muted or not on load to match muteButton state
        //Check audio level against sound of notifications incoming
        if let whiteNoiseFilePath = Bundle.main.path(forResource: "whiteNoise", ofType: "mp3") {
            let url = URL(fileURLWithPath: whiteNoiseFilePath)
            do {
                whiteNoisePlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        whiteNoisePlayer.volume = 0
        whiteNoisePlayer.numberOfLoops = -1
        
        if let alertSoundFilePath = Bundle.main.path(forResource: "glass_Done", ofType: "wav") {
            let url = URL(fileURLWithPath: alertSoundFilePath)
            do {
                alertSoundPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        alertSoundPlayer.volume = 2
        alertSoundPlayer.numberOfLoops = 0
        
        if let startButtonSoundFilePath = Bundle.main.path(forResource: "rainbow1", ofType: "wav") {
            let url = URL(fileURLWithPath: startButtonSoundFilePath)
            do {
                startButtonSoundPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        startButtonSoundPlayer.volume = 2
        startButtonSoundPlayer.numberOfLoops = 0
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        if pdTimer.settingsMenuState == .open {
            settingsButton.alpha = 0.25
            settingsView.alpha = 0
            pdTimer.settingsMenuState = .closed
        }
        
        if pdTimer.resetButtonState == .notTapped {
            pdTimer.resetButtonState = .tapped
            for button in topContainerButtons {
                button.isEnabled = false
                button.alpha = 0
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
                button.alpha = 100
            }
            for label in topContainerLabels {
                label.isHidden = false
            }
            resetButton.alpha = 0.25
            resetView.alpha = 0
        }
    }
    
    @IBAction func tapToResetButtonTapped(_ sender: Any) {
        PDTimerController.shared.reset()
        whiteNoisePlayer.stop()
        whiteNoisePlayer.volume = 0
        PDTimerController.shared.pdTimer.workState = .working
        PDTimerController.shared.setTimeRemaining()
        PDTimerController.shared.toggleMessage()
        messageLabel.text = pdTimer.timerMessage
        PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
            self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
        }
        self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
        for button in topContainerButtons {
            button.isEnabled = true
            button.alpha = 100
        }
        for label in topContainerLabels {
            label.isHidden = false
        }
        resetButton.alpha = 0.25
        resetView.alpha = 0
        pdTimer.resetButtonState = .notTapped
    }
    
    @IBAction func muteButtonTapped(_ sender: Any) {
        if pdTimer.audioSettingsState == .soundOn {
            pdTimer.audioSettingsState = .soundOff
            muteButton.alpha = 100
            whiteNoisePlayer.volume = 0
        } else if pdTimer.audioSettingsState == .soundOff {
            pdTimer.audioSettingsState = .soundOn
            muteButton.alpha = 0.25
            whiteNoisePlayer.setVolume(1, fadeDuration: 1)
        }
        PDTimerController.shared.saveToPersistentStore()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        if pdTimer.resetButtonState == .tapped {
            resetButton.alpha = 0.25
            resetView.alpha = 0
            pdTimer.resetButtonState = .notTapped
        }
        
        if pdTimer.settingsMenuState == .closed {
            pdTimer.settingsMenuState = .open
            for button in topContainerButtons {
                button.isEnabled = false
                button.alpha = 0
            }
            for label in topContainerLabels {
                label.isHidden = true
            }
            settingsButton.alpha = 100
            settingsView.alpha = 100
        } else if pdTimer.settingsMenuState == .open {
            pdTimer.settingsMenuState = .closed
            for button in topContainerButtons {
                button.isEnabled = true
                button.alpha = 100
            }
            for label in topContainerLabels {
                label.isHidden = false
            }
            settingsButton.alpha = 0.25
            settingsView.alpha = 0
        }
    }
    
    @IBAction func tapToTurnOffNotificationsButtonTapped(_ sender: Any) {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return}
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL) { (success) in
                print("Settings open: \(success)")
            }
        }
        for button in topContainerButtons {
            button.isEnabled = true
            button.isHidden = false
        }
        for label in topContainerLabels {
            label.isHidden = false
        }
        settingsView.alpha = 0
        settingsButton.alpha = 0.25
        pdTimer.settingsMenuState = .closed
    }
    
    @IBAction func decreaseBreakLengthTapped(_ sender: Any) {
        if pdTimer.breakLength > 1 {
            pdTimer.breakLength -= 1
            if pdTimer.workState == .onBreak {
                timerLabel.text = "\(Int(pdTimer.breakLength)):00"
            }
            breakLengthLabel.text = String(Int(pdTimer.breakLength))
        }
        AudioServicesPlaySystemSound(1105)
    }
    
    @IBAction func increaseBreakLengthTapped(_ sender: Any) {
        if pdTimer.breakLength < 60 {
            pdTimer.breakLength += 1
            if pdTimer.workState == .onBreak {
                timerLabel.text = "\(Int(pdTimer.breakLength)):00"
            }
            breakLengthLabel.text = String(Int(pdTimer.breakLength))
            AudioServicesPlaySystemSound(1105)
        }
    }
    
    @IBAction func decreaseSessionLengthTapped(_ sender: Any) {
        if pdTimer.workLength > 1 {
            pdTimer.workLength -= 1
            if pdTimer.workState == .working {
                timerLabel.text = "\(Int(pdTimer.workLength)):00"
            }
            sessionLengthLabel.text = String(Int(pdTimer.workLength))
        }
        AudioServicesPlaySystemSound(1105)
    }
    
    @IBAction func increaseSessionLengthTapped(_ sender: Any) {
        if pdTimer.workLength < 60 {
            pdTimer.workLength += 1
            if pdTimer.workState == .working {
                timerLabel.text = "\(Int(pdTimer.workLength)):00"
            }
            sessionLengthLabel.text = String(Int(pdTimer.workLength))
        }
        AudioServicesPlaySystemSound(1105)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        impactFeedbackGenerator.prepare()
        PDTimerController.shared.toggleMessage()
        if pdTimer.timerState == .ready {
            pdTimer.timerState = .running
            for button in topContainerButtons {
                button.isEnabled = false
                button.alpha = 0
            }
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            impactFeedbackGenerator.impactOccurred()
            startButtonSoundPlayer.play()
            runTimer()
            whiteNoisePlayer.play()
            if pdTimer.audioSettingsState == .soundOff {
                whiteNoisePlayer.volume = 0
            } else if pdTimer.audioSettingsState == .soundOn {
                whiteNoisePlayer.setVolume(1, fadeDuration: 3)
            }
            
        } else if pdTimer.timerState == .running  {
            PDTimerController.shared.stop()
            impactFeedbackGenerator.impactOccurred()
            whiteNoisePlayer.pause()
            whiteNoisePlayer.volume = 0
            pdTimer.timerState = .stopped
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
        } else if pdTimer.timerState == .stopped {
            pdTimer.timerState = .running
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            runTimer()
            impactFeedbackGenerator.impactOccurred()
            whiteNoisePlayer.play()
            if pdTimer.audioSettingsState == .soundOff {
                whiteNoisePlayer.volume = 0
            } else if pdTimer.audioSettingsState == .soundOn {
                whiteNoisePlayer.setVolume(1, fadeDuration: 3)
            }
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
    var whiteNoisePlayer = AVAudioPlayer()
    var alertSoundPlayer = AVAudioPlayer()
    var startButtonSoundPlayer = AVAudioPlayer()
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
}
