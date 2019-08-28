//
//  SplashScreenViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 8/24/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overlayLeadingConstraint.constant = overlayImageView.frame.width
        topContainerTopConstraint.constant = -(topContainerView.frame.height + 1000)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var overlayLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerView: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
