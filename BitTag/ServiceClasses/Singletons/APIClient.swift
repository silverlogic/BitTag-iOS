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
        // Add descriptors
        restKitManager?.addResponseDescriptors(from: [clientErrorResponseDescriptor!,
                                                      serverErrorResponseDescriptor!,
                                                      postSocialAuthResponseDescritptor!,
                                                      getUserResponseDescriptor!])
        // Set default header
        restKitManager?.httpClient.setDefaultHeader("Authorization", value: "Token \(BTUser.getToken())")
    }
}
