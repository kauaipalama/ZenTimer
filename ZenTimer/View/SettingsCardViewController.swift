//
//  SettingsCardViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 1/7/21.
//  Copyright © 2021 Kainoa Palama. All rights reserved.
//

import UIKit

class SettingsCardViewController: UIViewController, CardViewDelegate {
    
    func displayScrollIndicator() {
        //display scroll indicator here
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupViews() {
        
    }
    
    @IBAction func toggleDynamicBackgroundSwitched(_ sender: Any) {
    }
    
    @IBAction func toggleNotificationsSwitched(_ sender: Any) {
    }
    
    @IBAction func togglePersonalizedAdsSwitched(_ sender: Any) {
    }
    
    @IBAction func goToDeviceSettingsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func purchaseRemoveAdsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func restoreAllPurchasesButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var dynamicBackgroundLabel: UILabel!
    @IBOutlet weak var dynamicBackgroundLabel2: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var notificationsLabel2: UILabel!
    @IBOutlet weak var personalizedAdsLabel: UILabel!
    @IBOutlet weak var personalizedAdLabel2: UILabel!
    @IBOutlet weak var goToDeviceSettingsButton: UIButton!
    @IBOutlet weak var inAppPurchasesLabel: UILabel!
    @IBOutlet weak var removeAdsLabel1: UILabel!
    @IBOutlet weak var removeAdsLabel2: UILabel!
    @IBOutlet weak var restoreAllPurchasesButton: UIButton!
}
