//
//  BTTabBarViewController.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class BTTabBarViewController: UITabBarController {
    
    // MARK: - Attributes
    var userLoggedOutClosure: (() -> Void)?
}


// MARK: - Lifecycle
extension BTTabBarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUser), name: .Logout, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


// MARK: - Private Instance Methods
extension BTTabBarViewController {
    @objc fileprivate func logoutUser() {
        guard let closure = userLoggedOutClosure else { return }
        closure()
    }
}
