//
//  BTUser.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class BTUser: NSObject {
    
    // MARK: - Attributes
    fileprivate var _userId = 0 as NSNumber
    fileprivate var _avatarUrl: NSURL?
    fileprivate var _firstName = "" as NSString
    fileprivate var _lastName = "" as NSString
    fileprivate var _token = "" as NSString
    fileprivate var _facebookAccessToken = "" as NSString
    fileprivate var _apnsToken = "" as NSString
}


// MARK: - Getters & Setters
extension BTUser {
    var userId: NSNumber {
        get {
            return _userId
        }
        set {
            _userId = newValue
        }
    }
    
    var avatarUrl: NSURL? {
        get {
            return _avatarUrl
        }
        set {
            _avatarUrl = newValue
        }
    }
    
    var firstName: NSString {
        get {
            return _firstName
        }
        set {
            _firstName = newValue
        }
    }
    
    var lastName: NSString {
        get {
            return _lastName
        }
        set {
            _lastName = newValue
        }
    }
    
    var token: NSString {
        get {
            return _token
        }
        set {
            _token = newValue
            UserDefaults.standard.set(_token, forKey: "token")
        }
    }
    
    var facebookAccessToken: NSString {
        get {
            return _facebookAccessToken
        }
        set {
            _facebookAccessToken = newValue
        }
    }

    var apnsToken: NSString {
        get {
            guard let pushToken = UserDefaults.standard.value(forKey: "apnsToken") as? NSString else {
                return ""
            }
            return pushToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "apnsToken")
        }
    }
}


// MARK: - Public Class Methods
extension BTUser {
    class func fieldMappings() -> [String:String] {
        return ["id":"userId",
                "avatar.full_size":"avatarUrl",
                "first_name":"firstName",
                "last_name":"lastName",
                "token":"token",
                "access_token":"facebookAccessToken",
                "apns_token":"apnsToken"]
    }
    
    class func getToken() -> NSString {
        guard let token = UserDefaults.standard.value(forKey: "token") as? NSString else {
            return ""
        }
        return token
    }
}
