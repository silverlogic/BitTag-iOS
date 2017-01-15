//
//  BluetoothDiscover.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation
import Discovery

final class BluetoothDiscover {
    
    // MARK: - Private Attributes
    fileprivate let _serviceUUID = CBUUID(string: "B9407F30-F5F8-466E-AFF9-25556B57FE99")
    fileprivate var _inAppBluetoothUsers = [BLEUser]()
    fileprivate var _identifier: String!
    fileprivate var _discovery: Discovery!
    
    
    // MARK: - Public Attributes
    var bluetoothUsersInAppUpdated: (() -> Void)?
    
    
    // MARK: - Initializers
    init(identifier: String) {
        _identifier = identifier
        _discovery = Discovery(uuid: _serviceUUID, username: _identifier, startOption: .none, usersBlock: { [weak self] (users: [Any]?, usersChanges: Bool) in
            guard let inAppUsers = users as? [BLEUser],
                  let strongSelf = self,
                  let closure = strongSelf.bluetoothUsersInAppUpdated else { return }
            strongSelf._inAppBluetoothUsers = inAppUsers
            closure()
        })
        _discovery.shouldAdvertise = true
        _discovery.shouldDiscover = true
    }
}


// MARK: - Public Instance Methods For Data Source Status
extension BluetoothDiscover {
    func totalNumberOfInAppBluetoothUsers() -> Int {
        return _inAppBluetoothUsers.count
    }
}


// MARK: - Public Instance Methods For Querying In App Bluetooth Users
extension BluetoothDiscover {
    func inAppBluetoothUserWithIndex(_ index: Int) -> String? {
        if index > _inAppBluetoothUsers.count - 1 || index < _inAppBluetoothUsers.count - 1 {
            return nil
        }
        return _inAppBluetoothUsers[index].username
    }
}


// MARK: - Public Instance Methods For Bluetooth
extension BluetoothDiscover {
    func stopAdvertiseService() {
        _discovery.shouldAdvertise = false
    }
    
    func stopDiscoveringInAppUsers() {
        _discovery.shouldDiscover = false
    }
}
