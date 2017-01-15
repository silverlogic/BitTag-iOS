//
//  BTParticipant.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class BTParticipant: NSObject {
    
    // MARK: - Attributes
    fileprivate var _participantId = 0 as NSNumber
    fileprivate var _gameId = 0 as NSNumber
    fileprivate var _user: BTUser!
    fileprivate var _userId = 0 as NSNumber
    fileprivate var _status = "" as NSString
}


// MARK: - Getters & Setters
extension BTParticipant {
    var participantId: NSNumber {
        get {
            return _participantId
        }
        set {
            _participantId = newValue
        }
    }
    
    var gameId: NSNumber {
        get {
            return _gameId
        }
        set {
            _gameId = newValue
        }
    }
    
    var user: BTUser {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }
    
    var userId: NSNumber {
        get {
            return _userId
        }
        set {
            _userId = newValue
        }
    }
    
    var status: NSString {
        get {
            return _status
        }
        set {
            _status = newValue
        }
    }
}


// MARK: - Public Class Methods
extension BTParticipant {
    class func fieldMappings() -> [String:String] {
        return ["id":"participantId",
                "game":"gameId",
                "status":"status",
                "user":"userId"]
    }
}
