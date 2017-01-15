//
//  SecondViewController.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SecondViewController: UIViewController {
    
}

extension SecondViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedOut), name: .FBSDKAccessTokenDidChange, object: nil)
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


extension SecondViewController {
    @objc fileprivate func userLoggedOut() {
        NotificationCenter.default.post(name: .Logout, object: nil)
    }
}
