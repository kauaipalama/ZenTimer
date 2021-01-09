//
//  SettingsCardViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 1/7/21.
//  Copyright © 2021 Kainoa Palama. All rights reserved.
//
//ToDo
//Init the SettingsCardViewController and the CardViewController in PDTimerViewController with logic to dismiss any other visible cards to avoid stacking and maintain continuity with similar design elements and their functionality. Only show one at a time.
//Once the card is visible and logic is in place we can work on making the calls and performing further logic.
import UIKit

class SettingsCardViewController: UIViewController, CardViewDelegate {
    
    func displayScrollIndicator() {
        //display scroll indicator here? Clean up logic in CardViewController then replicate here. The original issue was due to the scroll indicator not flashing after the view has finished animating. Not 100 percent, but thats the jist. Fix it.
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //You were calling display scrollindicator here in CardViewController with a dispatch. why. and why nest the flash call in another function. fix that then come back to see me.
        
        //Answer: call was nested in order to conform to a protocol set in PDTimerViewController in order to get triggered at the end of the card animation. Assuming was designed in order to contain all outlets in the CardViewController.xib file
    }
    
    func setupViews() {
        settingLabel.text = Constants.settings
        dynamicBackgroundLabel.text = Constants.dynamicBackground
        dynamicBackgroundLabel2.text = Constants.dynamicBackgroundSettingDescription
        notificationsLabel.text = Constants.notifications
        notificationsLabel2.text = Constants.notificationsSettingDescription
        personalizedAdsLabel.text = Constants.personalizedAds
        personalizedAdLabel2.text = Constants.personalizedAdsSettingDescription
        goToDeviceSettingsButton.titleLabel?.text = Constants.goToDeviceSettings
        inAppPurchasesLabel.text = Constants.inAppPurchases
        removeAdsLabel1.text = Constants.removeAds
        removeAdsLabel2.text = Constants.removeAdsSettingDescription
        restoreAllPurchasesButton.titleLabel?.text = Constants.restoreAllPurchases
        //Need to setup removeAdsButton title with price of local using storekit. Also need to be able to get denom symbol in similar call. Will have to switch to "purchased" after in app purchase is made or restored. Make calls in IBActions (purchase and restore tapped).
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
    @IBOutlet weak var removeAdsButton: UIButton!
}
