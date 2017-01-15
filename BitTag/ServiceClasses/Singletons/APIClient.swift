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
    fileprivate let _userEndpoint = "users/me"
    
    
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
        let extendedErrorResponseMapping = RKObjectMapping(for: BTExtendedError.classForCoder())
        extendedErrorResponseMapping?.addAttributeMappings(from: BTExtendedError.fieldMappings())
        let userResponseMapping = RKObjectMapping(for: BTUser.classForCoder())
        userResponseMapping?.addAttributeMappings(from: BTUser.fieldMappings())
        // Set up response descriptors
        let clientErrorResponseDescriptor = RKResponseDescriptor(mapping: extendedErrorResponseMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: clientErrorStatusCode)
        let serverErrorResponseDescriptor = RKResponseDescriptor(mapping: extendedErrorResponseMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: serverErrorStatusCode)
        let postSocialAuthResponseDescritptor = RKResponseDescriptor(mapping: userResponseMapping, method: .POST, pathPattern: _socialAuthEndpoint, keyPath: nil, statusCodes: successStatusCode)
        let getUserResponseDescriptor = RKResponseDescriptor(mapping: userResponseMapping, method: .GET, pathPattern: _userEndpoint, keyPath: nil, statusCodes: successStatusCode)
        // Set up request descriptors
        let userRequestMapping = userResponseMapping?.inverse()
        let postSocialAuthRequestDescriptor = RKRequestDescriptor(mapping: userRequestMapping, objectClass: BTUser.classForCoder(), rootKeyPath: nil, method: .POST)
        // Add descriptors
        restKitManager?.addRequestDescriptors(from: [postSocialAuthRequestDescriptor!])
        restKitManager?.addResponseDescriptors(from: [clientErrorResponseDescriptor!,
                                                      serverErrorResponseDescriptor!,
                                                      postSocialAuthResponseDescritptor!,
                                                      getUserResponseDescriptor!])
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
}
