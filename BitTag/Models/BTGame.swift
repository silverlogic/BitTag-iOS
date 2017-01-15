//
//  BTGame.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class BTGame: NSObject {
    
    // MARK: - Attributes
    fileprivate var _gameId = 0 as NSNumber
    fileprivate var _ownerId = 0 as NSNumber
    fileprivate var _centerPointType = "" as NSString
    fileprivate var _coordinates = [0.0 as NSNumber, 0.0 as NSNumber]
    fileprivate var _radius = 0.0 as NSNumber
    fileprivate var _buyin = "" as NSString
    fileprivate var _status = "" as NSString
}


// MARK: - Getters & Setters
extension BTGame {
    var gameId: NSNumber {
        get {
            return _gameId
        }
        set {
            _gameId = newValue
        }
    }
    
    var ownerId: NSNumber {
        get {
            return _ownerId
        }
        set {
            _ownerId = newValue
        }
    }
    
    var centerPointType: NSString {
        get {
            return _centerPointType
        }
        set {
            _centerPointType = newValue
        }
    }
    
    var coordinates: [NSNumber] {
        get {
            return _coordinates
        }
        set {
            _coordinates = newValue
        }
    }
    
    var radius: NSNumber {
        get {
            return _radius
        }
        set {
            _radius = newValue
        }
    }
    
    var buyin: NSString {
        get {
            return _buyin
        }
        set {
            _buyin = newValue
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
extension BTGame {
    class func fieldMappings() -> [String:String] {
        return ["id":"gameId",
                "owner":"ownerId",
                "center_point.type":"centerPointType",
                "center_point.coordinates":"coordinates",
                "radius":"radius",
                "buy_in":"buyin",
                "status":"status"]
    }
}
