//
//  AuthenticationManager.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class AuthenticationManager {
    
    // MARK: - Shared Instance
    static let shared = AuthenticationManager()
    
    
    // MARK: - Attributes
    fileprivate var _currentUser: BTUser!
    
    
    // Initializers
    private init() {}
}


// MARK: - Public Instance Methods
extension AuthenticationManager {
    func loginUserWithAccessToken(_ accessToken: String, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        _currentUser = BTUser()
        _currentUser.facebookAccessToken = accessToken as NSString
        APIClient.shared.postSocialAuth(user: _currentUser, success: { (user: BTUser) in
            self._currentUser = user
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    func logoutCurrentUser() {
        _currentUser.token = ""
        _currentUser = nil
    }
    
    func loadCurrentUser(success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        _currentUser = BTUser()
        APIClient.shared.getUser(_currentUser, success: { (user: BTUser) in
            self._currentUser = user
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
}
