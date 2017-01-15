//
//  BTInitialNavigationController.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

final class BTInitialNavigationController: UINavigationController {
}


// MARK: - Lifecycle
extension BTInitialNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
}


// MARK: - Pirvate Instance Methods
extension BTInitialNavigationController {
    fileprivate func initializeView() {
        if FBSDKAccessToken.current() != nil {
            AuthenticationManager.shared.loadCurrentUser(success: { 
                self.showTabBarController()
            }, failure: { (error: Error?) in
                self.showFacebookLoginViewController()
            })
        } else {
            showFacebookLoginViewController()
        }
    }
    
    fileprivate func showFacebookLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let facebookLoginViewController = storyboard.instantiateViewController(withIdentifier: "BTFacebookLoginViewController") as? BTFacebookLoginViewController else { return }
        facebookLoginViewController.userLoggedInClosure = {
            self.showTabBarController()
        }
        setViewControllers([facebookLoginViewController], animated: true)
    }
    
    fileprivate func showTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "BTTabBarViewController") as? BTTabBarViewController else { return }
        tabBarController.userLoggedOutClosure = {
            self.showFacebookLoginViewController()
        }
        setViewControllers([tabBarController], animated: true)
    }
}
