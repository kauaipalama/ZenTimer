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
            settingsButton.alpha = 0.25
        } else {
            settingsMenuOpen = true
            settingsButton.alpha = 100
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
            timerDidStart = true
            startButton.setTitle("TAP TO PAUSE", for: .normal)
        } else {
            timerDidStart = false
            startButton.setTitle("TAP TO START", for: .normal)
        }
    }
    
    
    // MARK: - IBObjects
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var breakLengthLabel: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    
    // MARK: - Parameters
    
    var sessionLength = 25
    var breakLength = 5
    var isMuted = false
    var settingsMenuOpen = false
    var timerDidStart = false
    
}
