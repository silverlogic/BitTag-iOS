//
//  BTFacebookLoginViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class BTFacebookLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
}
