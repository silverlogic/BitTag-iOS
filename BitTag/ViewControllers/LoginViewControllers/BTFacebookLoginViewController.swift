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
import SVProgressHUD

final class BTFacebookLoginViewController: UIViewController {
    
    // MARK: - Attributes
    var userLoggedInClosure: (() -> Void)?
}


// MARK: - Lifecycle
extension BTFacebookLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


// MARK: - Private Instance Methods
extension BTFacebookLoginViewController {
    fileprivate func initializeView() {
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: .FBSDKAccessTokenDidChange, object: nil)
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        self.view.addSubview(loginButton)
    }
    
    @objc fileprivate func userLoggedIn() {
        SVProgressHUD.show()
        DispatchQueue.global(qos: .default).async {
            AuthenticationManager.shared.loginUserWithAccessToken(FBSDKAccessToken.current().tokenString, success: {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    guard let closure = self.userLoggedInClosure else { return }
                    closure()
                }
            }) { (error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription ?? NSLocalizedString("Miscellaneous.UnKnownError", comment: "unknown error"))
                    SVProgressHUD.dismiss(withDelay: 2.0)
                }
            }
        }
    }
}
