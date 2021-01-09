//
//  TrackerConfigurationValidator.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/29/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

struct TrackerConfigurationValidator {
    private init() {}
    
    static func deviceIdValid(deviceId: String) throws {
        if (deviceId.isEmpty) {
            throw TrackerMisconfiguration.deviceIdMustNotBeNilOrEmpty
        }
    }
    
    static func externalUserIdValid(externalUserId: String) throws {
        if (externalUserId.isEmpty) {
            throw TrackerMisconfiguration.externalUserIdMustNotBeNilOrEmpty
        }
    }
    
    static func breadcrumbApiKeyValid(breadcrumbApiKey: String) throws {
        if (breadcrumbApiKey.isEmpty) {
            throw TrackerMisconfiguration.breadcrumbApiKeyMustNotBeNilOrEmpty
        }
    }
}
