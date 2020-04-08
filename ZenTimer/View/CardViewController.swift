//
//  CardViewController.swift
//  ZenTimer
//
//  Created by Kainoa Palama on 10/12/19.
//  Copyright © 2019 Kainoa Palama. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        footerTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        footerTextView.textContainer.lineFragmentPadding = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //This doesnts work when trying to flash the scrollIndicator after the view has loaded and animated. MAybe consider using a delegate to fire the method.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
            self.scrollView.flashScrollIndicators()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var footerTextView: UITextView!
}
