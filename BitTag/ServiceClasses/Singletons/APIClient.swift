//
//  APIClient.swift
//  BitTag
//
//  Created by Emanuel  Guerrero on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import Foundation
import RestKit

final class APIClient {
    
    // MARK: - Shared Instance
    static let shared = APIClient()
    
    
    // MARK: - Attributes
    fileprivate let _socialAuthEndpoint = "social-auth"
    fileprivate let _usersEndpoint = "users"
    fileprivate let _userEndpoint = "users/me"
    fileprivate let _participantsEndpoint = "participants"
    fileprivate let _participantsJoinGameEndpoint = "participants/:participantId/join"
    fileprivate let _participantsTaggedParticipantEndpoint = "participants/:participantId/tag"
    fileprivate let _gamesEndpoint = "games"
    fileprivate let _gameEndpoint = "games/:gameId"
    fileprivate let _gameStartEndpoint = "games/:gameId/start"
    
    
    // MARK: - Initializers
    private init() {
        RKlcl_configure_by_name("RestKit/Network", RKlcl_vTrace.rawValue);
        RKlcl_configure_by_name("RestKit/ObjectMapping", RKlcl_vOff.rawValue);
        let restKitManager = RKObjectManager(baseURL: URL(string: "http://api.bit-tag.tsl.io/v1"))
        restKitManager?.requestSerializationMIMEType = RKMIMETypeJSON
        // Set up status codes
        let successStatusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.successful)
        let clientErrorStatusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.clientError)
        let serverErrorStatusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.serverError)
        // Set up mappings
        let emptyResponseMapping = RKObjectMapping(for: NSDictionary.classForCoder())
        let extendedErrorResponseMapping = RKObjectMapping(for: BTExtendedError.classForCoder())
        extendedErrorResponseMapping?.addAttributeMappings(from: BTExtendedError.fieldMappings())
        let userResponseMapping = RKObjectMapping(for: BTUser.classForCoder())
        userResponseMapping?.addAttributeMappings(from: BTUser.fieldMappings())
        let participantResponseMapping = RKObjectMapping(for: BTParticipant.classForCoder())
        participantResponseMapping?.addAttributeMappings(from: BTParticipant.fieldMappings())
        participantResponseMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "user", toKeyPath: "user", with: userResponseMapping))
        let gameResponseMapping = RKObjectMapping(for: BTGame.classForCoder())
        gameResponseMapping?.addAttributeMappings(from: BTGame.fieldMappings())
        // Set up response descriptors
        let clientErrorResponseDescriptor = RKResponseDescriptor(mapping: extendedErrorResponseMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: clientErrorStatusCode)
        let serverErrorResponseDescriptor = RKResponseDescriptor(mapping: extendedErrorResponseMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: serverErrorStatusCode)
        let postSocialAuthResponseDescritptor = RKResponseDescriptor(mapping: userResponseMapping, method: .POST, pathPattern: _socialAuthEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let getUserResponseDescriptor = RKResponseDescriptor(mapping: userResponseMapping, method: .GET, pathPattern: _userEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let getUsersResponseDescriptor = RKResponseDescriptor(mapping: userResponseMapping, method: .GET, pathPattern: _usersEndpoint, keyPath: "results", statusCodes: successStatusCode)
        let postParticipantResponseDescriptor = RKResponseDescriptor(mapping: participantResponseMapping, method: .POST, pathPattern: _participantsEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let getParticipantsResponseDescriptor = RKResponseDescriptor(mapping: participantResponseMapping, method: .GET, pathPattern: _participantsEndpoint, keyPath: "results", statusCodes: successStatusCode)
        let postParticipantsJoinResponseDescriptor = RKResponseDescriptor(mapping: emptyResponseMapping, method: .POST, pathPattern: _participantsJoinGameEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let postParticipantTaggedParticipantResponseDescriptor = RKResponseDescriptor(mapping: emptyResponseMapping, method: .POST, pathPattern: _participantsTaggedParticipantEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let postGameResponseDescriptor = RKResponseDescriptor(mapping: gameResponseMapping, method: .POST, pathPattern: _gamesEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let getGamesResponseDescriptor = RKResponseDescriptor(mapping: gameResponseMapping, method: .GET, pathPattern: _gamesEndpoint, keyPath: "results", statusCodes: successStatusCode)
        let getGameResponseDescriptor = RKResponseDescriptor(mapping: gameResponseMapping, method: .GET, pathPattern: _gameEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let postGameStartResponseDescriptor = RKResponseDescriptor(mapping: emptyResponseMapping, method: .POST, pathPattern: _gameStartEndpoint, keyPath: nil, statusCodes: successStatusCode)
        // Set up request descriptors
        let userRequestMapping = userResponseMapping?.inverse()
        userRequestMapping?.assignsDefaultValueForMissingAttributes = false
        let postSocialAuthRequestDescriptor = RKRequestDescriptor(mapping: userRequestMapping, objectClass: BTUser.classForCoder(), rootKeyPath: nil, method: .POST)
        let participantRequestMapping = participantResponseMapping?.inverse()
        participantRequestMapping?.assignsDefaultValueForMissingAttributes = false
        let postParticipantRequestDescriptor = RKRequestDescriptor(mapping: participantRequestMapping, objectClass: BTParticipant.classForCoder(), rootKeyPath: nil, method: .POST)
        let gameRequestMapping = gameResponseMapping?.inverse()
        gameResponseMapping?.assignsDefaultValueForMissingAttributes = false
        let postGameRequestDescriptor = RKRequestDescriptor(mapping: gameRequestMapping, objectClass: BTGame.classForCoder(), rootKeyPath: nil, method: .POST)
        // Add descriptors
        restKitManager?.addRequestDescriptors(from: [postSocialAuthRequestDescriptor!,
                                                     postParticipantRequestDescriptor!,
                                                     postGameRequestDescriptor!])
        restKitManager?.addResponseDescriptors(from: [clientErrorResponseDescriptor!,
                                                      serverErrorResponseDescriptor!,
                                                      postSocialAuthResponseDescritptor!,
                                                      getUserResponseDescriptor!,getUsersResponseDescriptor!,
                                                      postParticipantResponseDescriptor!,getParticipantsResponseDescriptor!,postParticipantsJoinResponseDescriptor!,postParticipantTaggedParticipantResponseDescriptor!,
                                                      postGameResponseDescriptor!,getGamesResponseDescriptor!,getGameResponseDescriptor!,postGameStartResponseDescriptor!])
        // Set default header
        if BTUser.getToken().length > 0 {
            restKitManager?.httpClient.setDefaultHeader("Authorization", value: "Token \(BTUser.getToken())")
        } else {
            restKitManager?.httpClient.clearAuthorizationHeader()
        }
    }
}


// MARK: - User endpoints
extension APIClient {
    func postSocialAuth(user: BTUser, success: @escaping (_ user: BTUser) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().post(user, path: _socialAuthEndpoint, parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let user = mappingResult?.firstObject as? BTUser else {
                failure(nil)
                return
            }
            RKObjectManager.shared().httpClient.setDefaultHeader("Authorization", value: "Token \(user.token)")
            self.getUser(user, success: { (user: BTUser) in
                success(user)
            }, failure: { (error: Error?) in
                guard let getUserError = error else {
                    failure(nil)
                    return
                }
                failure(getUserError)
            })
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func getUser(_ user: BTUser, success: @escaping (_ user: BTUser) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().getObject(user, path: _userEndpoint, parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let user = mappingResult?.firstObject as? BTUser else {
                failure(nil)
                return
            }
            success(user)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func getUsers(success: @escaping (_ users: [BTUser]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().getObjectsAtPath(_usersEndpoint, parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let users = mappingResult?.array() as? [BTUser] else {
                failure(nil)
                return
            }
            success(users)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
}


// MARK: - Participant Endpoints
extension APIClient {
    func postParticipant(_ participant: BTParticipant, success: @escaping (_ participant: BTParticipant) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        let parameters = ["user":participant.userId]
        RKObjectManager.shared().post(participant, path: _participantsEndpoint, parameters: parameters, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let participant = mappingResult?.firstObject as? BTParticipant else {
                failure(nil)
                return
            }
            success(participant)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func getParticipants(parameters: [String: Any]?, success: @escaping (_ participants: [BTParticipant]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().getObjectsAtPath(_participantsEndpoint, parameters: parameters, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let participants = mappingResult?.array() as? [BTParticipant] else {
                failure(nil)
                return
            }
            success(participants)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func postParticipantJoiningGame(participant: BTParticipant, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().post(nil, path: RKPathFromPatternWithObject(_participantsJoinGameEndpoint, participant), parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            success()
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func postParticipantGettingTagged(participant: BTParticipant, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().post(participant, path: RKPathFromPatternWithObject(_participantsTaggedParticipantEndpoint, participant), parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            success()
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
}


// MARK: - Game Endpoints
extension APIClient {
    func postGame(_ game: BTGame, success: @escaping (_ game: BTGame) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().post(game, path: _gamesEndpoint, parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let game = mappingResult?.firstObject as? BTGame else {
                failure(nil)
                return
            }
            success(game)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func getGame(_ game: BTGame, success: @escaping (_ game: BTGame) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().getObject(game, path: RKPathFromPatternWithObject(_gameEndpoint, game), parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let game = mappingResult?.firstObject as? BTGame else {
                failure(nil)
                return
            }
            success(game)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
    
    func getGames(success: @escaping (_ games: [BTGame]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().getObjectsAtPath(_gamesEndpoint, parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            guard let games = mappingResult?.array() as? [BTGame] else {
                failure(nil)
                return
            }
            success(games)
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }

    func postGameStart(game: BTGame, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        RKObjectManager.shared().post(game, path: RKPathFromPatternWithObject(_gameStartEndpoint, game), parameters: nil, success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
            success()
        }) { (operation: RKObjectRequestOperation?, error: Error?) in
            failure(error!)
        }
    }
}
