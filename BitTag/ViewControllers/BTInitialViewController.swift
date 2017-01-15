//
//  BTInitialViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class BTInitialViewController: UIViewController {
    
    // MARK: - Attributes
    var userLoggedOutClosure: (() -> Void)?
}


// MARK: - Lifecycle
extension BTInitialViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUser), name: .Logout, object: nil)
        performSegue(withIdentifier: "gotoApplication", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


// MARK: - Private Instance Methods
extension BTInitialViewController {
    @objc fileprivate func logoutUser() {
        guard let closure = userLoggedOutClosure else { return }
        closure()
    }
}

