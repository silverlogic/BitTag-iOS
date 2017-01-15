//
//  ParticipantsManager.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class ParticipantsManager {
    
    // MARK: - Shared Instance
    static let shared = ParticipantsManager()
    
    
    // MARK: - Initializers
    private init() {}
}


// MARK: - Public Instance Methods
extension ParticipantsManager {
    func participantJoinGame(gameId: NSNumber, userId: NSNumber, success: @escaping (_ participate: BTParticipant) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let participant = BTParticipant()
        participant.gameId = gameId
        participant.userId = userId
        APIClient.shared.postParticipant(participant, success: { (participate: BTParticipant) in
            success(participant)
        }) { (error: Error?) in
            failure(error!)
        }
    }
    
    func loadAvaliableParticipates(gameId: NSNumber?, userId: NSNumber?, status: NSString?, success: @escaping (_ participants: [BTParticipant]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        var parameters = [String:Any]()
        if gameId != nil || userId != nil || status != nil {
            if let game = gameId {
                parameters["game"] = "\(game)"
            }
            if let user = userId {
                parameters["user"] = "\(user)"
            }
            if let participantStatus = status {
                parameters["status"] = "\(participantStatus)"
            }
        }
        parameters["expand"] = "user"
        APIClient.shared.getParticipants(parameters: parameters, success: { (participants: [BTParticipant]) in
            success(participants)
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    func participantBuysIn(participant: BTParticipant, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        APIClient.shared.postParticipantJoiningGame(participant: participant, success: { 
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
    
    func participantGotTagged(participant: BTParticipant, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        APIClient.shared.postParticipantGettingTagged(participant: participant, success: { 
            success()
        }) { (error: Error?) in
            failure(error)
        }
    }
}
