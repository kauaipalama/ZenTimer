//
//  PDTimerViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/8/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class PDTimerViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        PDTimerController.shared.loadFromPersistentStore()
        setUpAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addPulseAnimation()
        UIView.animate(withDuration: 1, delay: 1, options: .curveLinear, animations: {
            self.messageLabel.layer.opacity = 1
        }) { (_) in
            if self.permissionsPresented == false {
                let options: UNAuthorizationOptions = [.alert, .badge, .sound]
                self.notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
                    if let error = error {
                        print(error)
                    }
                    UserDefaults.standard.set(true, forKey: "permissionsPresented")
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Views
    
    func setupUI(){
        resetView.alpha = 0
        settingsView.alpha = 0
        messageLabel.layer.opacity = 0
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
        setupCard()
    }
    
    func setupCard() {
        let paddingValue = UIApplication.shared.statusBarFrame.height + (self.view.frame.height * 0.07)
        cardHeight = self.view.frame.height - paddingValue
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = CGRect(x: 0, y: paddingValue, width: self.view.frame.width, height: self.view.frame.height - paddingValue)
        visualEffectView.isUserInteractionEnabled = false
        self.view.addSubview(visualEffectView)
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        
        addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        cardViewController.handleView.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleView.addGestureRecognizer(panGestureRecognizer)
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
                if self?.pdTimer.timeRemaining == 3 {
                    if UIApplication.shared.applicationState != .background && self?.pdTimer.audioSettingsState == .soundOn {
                        self?.preAlertSoundPlayer.prepareToPlay()
                        self?.preAlertSoundPlayer.play()
                        self?.preAlertSoundPlayer.setVolume(2, fadeDuration: 1)
                    }
                }
                if self?.pdTimer.timerState == .finished {
                    self?.whiteNoisePlayer.stop()
                    self?.startButtonSoundPlayer.stop()
                    self?.addPulseAnimation()
                    if let topContainerButtons = self?.topContainerButtons {
                        for button in topContainerButtons {
                            button.isEnabled = true
                            button.alpha = 100
                        }
                    }
                    if UIApplication.shared.applicationState != .background && self?.pdTimer.audioSettingsState == .soundOn {
                        self?.alertSoundPlayer.prepareToPlay()
                        self?.alertSoundPlayer.play()
                    } else if UIApplication.shared.applicationState != .background && self?.pdTimer.audioSettingsState == .soundOff {
                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                        var message: String {
                            var string = ""
                            if self?.pdTimer.workState == .onBreak {
                                string = "Break Completed"
                            } else if self?.pdTimer.workState == .working {
                                string = "Session Completed"
                            }
                            return string
                        }
                        let alert = UIAlertController(title: "message", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    
                    PDTimerController.shared.toggleWorkState()
                    self?.pdTimer.timerState = .ready
                    PDTimerController.shared.toggleMessage()
                    self?.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
                    PDTimerController.shared.setTimeRemaining()
                    self?.timerLabel.text = String(Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining))
                    PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                        self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                    }
                    PDTimerController.shared.scheduleAlarmNotification()
                    self?.whiteNoisePlayer.volume = 0
                    
                }
            })
            self.timerLabel.text = Double().secondsToMinutesAndSeconds(timeInterval: PDTimerController.shared.pdTimer.timeRemaining)
            PDTimerController.shared.toggleMessage()
            self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
        })
    }
    
    fileprivate func setUpAudio() {
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
        
        if let alertSoundFilePath = Bundle.main.path(forResource: "glass_DoneLoud", ofType: "wav") {
            let url = URL(fileURLWithPath: alertSoundFilePath)
            do {
                alertSoundPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        alertSoundPlayer.volume = 1
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
        
        if let pauseButtonSoundFilePath = Bundle.main.path(forResource: "rainbow2", ofType: "wav") {
            let url = URL(fileURLWithPath: pauseButtonSoundFilePath)
            do {
                pauseButtonSoundPlayer = try  AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        pauseButtonSoundPlayer.volume = 2
        pauseButtonSoundPlayer.numberOfLoops = 0
        
        if let preAlertSoundFile = Bundle.main.path(forResource: "rainbow3", ofType: "wav") {
            let url = URL(fileURLWithPath: preAlertSoundFile)
            do {
                preAlertSoundPlayer = try  AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        preAlertSoundPlayer.volume = 0
        preAlertSoundPlayer.numberOfLoops = 0
        
    }
    
    fileprivate func addPulseAnimation() {
        pulseAnimation.duration = 1.1
        pulseAnimation.fromValue = NSNumber(value: 0)
        pulseAnimation.toValue = NSNumber(value: 1)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        startButton.layer.add(pulseAnimation, forKey: nil)
    }
    
    fileprivate func addReversedPulseAnimation() {
        pulseAnimation.duration = 1.1
        pulseAnimation.fromValue = NSNumber(value: 1)
        pulseAnimation.toValue = NSNumber(value: 0)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        startButton.layer.add(pulseAnimation, forKey: nil)
    }
    
    @objc fileprivate func handleCardTap(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
            self.infoButton.alpha = 0.25
        default:
            break
        }
    }
    
    @objc fileprivate func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextCardState, duration: 0.9)
            self.infoButton.alpha = 0.25
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    fileprivate func animateTransitionIfNeeded(state: CardViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            
            frameAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    fileprivate func startInteractiveTransition(state: CardViewState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    fileprivate func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    fileprivate func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    
    // MARK: - Notification Center
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(removePulseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPulseAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        if type == .began {
            if pdTimer.timerState == .running {
                PDTimerController.shared.stop()
                pdTimer.timerState = .interrupted
                PDTimerController.shared.toggleStartButtonLabelMessage {
                    startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                }
                whiteNoisePlayer.volume = 0
                whiteNoisePlayer.pause()
            }
        } else if type == .ended {
            guard let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                //Interruption Ended - playback should resume
                if pdTimer.timerState == .interrupted && pdTimer.timerState != .paused {
                    runTimer()
                    pdTimer.timerState = .running
                    PDTimerController.shared.toggleStartButtonLabelMessage {
                        startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
                    }
                    whiteNoisePlayer.prepareToPlay()
                    whiteNoisePlayer.play()
                    whiteNoisePlayer.setVolume(1, fadeDuration: 3)
                }
            }
        }
    }
    
    @objc func removePulseAnimation() {
        startButton.layer.removeAllAnimations()
    }
    
    @objc func reloadPulseAnimation() {
        if pdTimer.timerState == .ready || pdTimer.timerState == .paused {
            addReversedPulseAnimation()
        }
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
        
        if cardVisible == true {
            animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
            infoButton.alpha = 0.25
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
        addReversedPulseAnimation()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        if nextCardState == .expanded {
            infoButton.alpha = 100
        } else if nextCardState == .collapsed {
            infoButton.alpha = 0.25
        }
        animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
        
        if pdTimer.settingsMenuState == .open {
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
        
        if pdTimer.resetButtonState == .tapped {
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
        
        if cardVisible == true {
            animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
            infoButton.alpha = 0.25
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
        if pdTimer.breakLength < 99 {
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
        if pdTimer.workLength < 99 {
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
            startButton.layer.removeAllAnimations()
            for button in topContainerButtons {
                button.isEnabled = false
                button.alpha = 0
            }
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            impactFeedbackGenerator.impactOccurred()
            runTimer()
            whiteNoisePlayer.prepareToPlay()
            whiteNoisePlayer.play()
            if pdTimer.audioSettingsState == .soundOff {
                whiteNoisePlayer.volume = 0
            } else if pdTimer.audioSettingsState == .soundOn {
                startButtonSoundPlayer.prepareToPlay()
                startButtonSoundPlayer.play()
                whiteNoisePlayer.setVolume(2, fadeDuration: 1)
            }
            
        } else if pdTimer.timerState == .running  {
            PDTimerController.shared.stop()
            if pdTimer.audioSettingsState == .soundOn {
                pauseButtonSoundPlayer.play()
            }
            impactFeedbackGenerator.impactOccurred()
            whiteNoisePlayer.pause()
            whiteNoisePlayer.volume = 0
            pdTimer.timerState = .paused
            PDTimerController.shared.toggleMessage()
            startButton.layer.removeAllAnimations()
            addPulseAnimation()
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
        } else if pdTimer.timerState == .paused {
            pdTimer.timerState = .running
            startButton.layer.removeAllAnimations()
            PDTimerController.shared.toggleStartButtonLabelMessage { [weak self] in
                self?.startButton.setTitle(PDTimerController.shared.pdTimer.startButtonMessage, for: .normal)
            }
            runTimer()
            impactFeedbackGenerator.impactOccurred()
            whiteNoisePlayer.play()
            if pdTimer.audioSettingsState == .soundOff {
                whiteNoisePlayer.volume = 0
            } else if pdTimer.audioSettingsState == .soundOn {
                startButtonSoundPlayer.prepareToPlay()
                startButtonSoundPlayer.play()
                whiteNoisePlayer.setVolume(2, fadeDuration: 1)
            }
        }
        PDTimerController.shared.toggleMessage()
        self.messageLabel.text = PDTimerController.shared.pdTimer.timerMessage
    }
    
    // MARK: - IBObjects
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
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
    var whiteNoisePlayer: AVAudioPlayer!
    var preAlertSoundPlayer: AVAudioPlayer!
    var alertSoundPlayer: AVAudioPlayer!
    var startButtonSoundPlayer: AVAudioPlayer!
    var pauseButtonSoundPlayer: AVAudioPlayer!
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    let notificationCenter = UNUserNotificationCenter.current()
    var permissionsPresented = UserDefaults.standard.bool(forKey: "permissionsPresented")
    
    var cardViewController: CardViewController!
    var visualEffectView: UIVisualEffectView!
    
    var cardHeight: CGFloat = 0
    let cardHandleAreaHeight: CGFloat = 36
    
    var cardVisible = false
    
    var nextCardState: CardViewState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
}
