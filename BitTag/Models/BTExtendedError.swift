//
//  BTExtendedError.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation
import RestKit.RKErrorMessage

final class BTExtendedError: RKErrorMessage {
    
    // MARK: - Attributes
    fileprivate var _firstName: NSArray!
    fileprivate var _lastName: NSArray!
    fileprivate var _email: NSArray!
    fileprivate var _token: NSArray!
}


// MARK: - Getters & Setters
extension BTExtendedError {
    var firstName: NSArray {
        get {
            return _firstName
        }
        set {
            _firstName = newValue
        }
    }
    
    var lastName: NSArray {
        get {
            return _lastName
        } set {
            _lastName = newValue
        }
    }
    
    var email: NSArray {
        get {
            return _email
        } set {
            _email = newValue
        }
    }
    
    var token: NSArray {
        get {
            return _token
        }
        set {
            _token = newValue
        }
    }
}


// MARK: - Private Instance Methods
extension BTExtendedError {
    fileprivate func appendErrors(_ errors: NSArray, key: NSString) {
        if errorMessage.characters.count > 0 {
            errorMessage = ""
        }
        errors.forEach { (object: Any) in
            guard let message = object as? String else {
                errorMessage = ""
                return
            }
            errorMessage = "\(message) 🤔"
        }
    }
}


// MARK: - Public Class Methods
extension BTExtendedError {
    class func fieldMappings() -> [String:String] {
        return ["first_name":"firstName",
                "last_name":"lastName",
                "email":"email",
                "token":"token"]
    }
}
