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
    
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var footerTextView: UITextView!
}
