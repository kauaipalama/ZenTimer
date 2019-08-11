//
//  PDTimerController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/10/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import Foundation

class PDTimerController {
    
    // MARK: - Initializer
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - Timer Functions
    
    func setDisplayedTime() {
        
    }
    
    func toggleMessage() {
        
    }
    
    func toggleStartButtonLabelTitle() {
        
    }
    
    func startTimer(){
        
    }
    
    func ready() {
        
    }
    
    func stopTimer() {
        
    }
    
    func fireAlarm() {
        
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        print("Saved")
    }
    
    func loadFromPersistentStore() {
        print("Loaded")
    }
    
    // MARK: - Properties
    
    static let shared = PDTimerController()
}
