//
//  PushNotificationManager.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class PushNotificationManager {
    
    // MARK: - Shared Instance
    static let shared = PushNotificationManager()
    
    
    // MARK: - Initializers
    private init() {
    }
}


// MARK: - Public Instance Methods For Registration
extension PushNotificationManager {
    func registerForPushNotifications() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
}


// MARK: - Public Instance Methods For Handling Push Notifications
extension PushNotificationManager {
    func handlePushNotification(userInfo: [AnyHashable : Any]) {
        guard let pushNotificationType = userInfo["type"] as? String else { return }
        switch pushNotificationType {
            case "you_invited":
                // @TODO: Handle onece invite flow created
            break
            case "participant_invited":
                // @TODO: Handle onece invite flow created
            break
            case "participant_joined":
                // @TODO: Handle onece invite flow created
            break
            case "game_started":
                // @TODO: Handle once game logic implemented
            break
            case "participant_tagged":
                // @TODO: Handle sending notification to update map
            break
            case "game_ended":
                // @TODO: Handle sending notification to update map
            break
        default:
            break
        }
    }
}
