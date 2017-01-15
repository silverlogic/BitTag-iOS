//
//  BTTagViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTTagViewController: UIViewController {

    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _tagButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        _imageView.layer.cornerRadius = (_imageView.frame.width / 2.0)
        _tagButton.layer.cornerRadius = 20.0
    }
    @IBAction func tagButtonTapped(_ sender: UIButton) {
    }
}
