//
//  NotificationName+Extensions.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let Logout = Notification.Name("Logout")
    static let UpdateCurrentGame = Notification.Name("UpdateCurrentGame")
    static let GameStarted = Notification.Name("GameStarted")
    static let GameEnded = Notification.Name("GameEnded")
    static let ParticipantJoined = Notification.Name("ParticipantJoined")
}
