//
//  CardViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 10/12/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, CardViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
            self.scrollView.flashScrollIndicators()
        }
    }
    
    func displayScrollIndicator() {
        scrollView.flashScrollIndicators()
    }
    
    func setupViews() {
        aboutLabel1.text = Constants.about_Title
        aboutLabel2.text = Constants.about_Description
        whyLabel1.text = Constants.why_Title
        whyLabel2.text = Constants.why_Description
        step1Label1.text = Constants.step1_Title
        step1Label2.text = Constants.step1_Description
        step2Label1.text = Constants.step2_Title
        step2Label2.text = Constants.step2_Description
        step3Label1.text = Constants.step3_Title
        step3Label2.text = Constants.step3_Description
        step4Label1.text = Constants.step4_Title
        step4Label2.text = Constants.step4_Description
        whatToDoLabel1.text = Constants.whatToDo_Title
        whatToDoLabel2.text = Constants.whatToDo_Description
        footerTextView.text = Constants.footerText
        
        footerTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        footerTextView.textContainer.lineFragmentPadding = 0
    }
    
    @IBOutlet weak var aboutLabel1: UILabel!
    @IBOutlet weak var aboutLabel2: UILabel!
    @IBOutlet weak var whyLabel1: UILabel!
    @IBOutlet weak var whyLabel2: UILabel!
    @IBOutlet weak var step1Label1: UILabel!
    @IBOutlet weak var step1Label2: UILabel!
    @IBOutlet weak var step2Label1: UILabel!
    @IBOutlet weak var step2Label2: UILabel!
    @IBOutlet weak var step3Label1: UILabel!
    @IBOutlet weak var step3Label2: UILabel!
    @IBOutlet weak var step4Label1: UILabel!
    @IBOutlet weak var step4Label2: UILabel!
    @IBOutlet weak var whatToDoLabel1: UILabel!
    @IBOutlet weak var whatToDoLabel2: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var footerTextView: UITextView!
}
