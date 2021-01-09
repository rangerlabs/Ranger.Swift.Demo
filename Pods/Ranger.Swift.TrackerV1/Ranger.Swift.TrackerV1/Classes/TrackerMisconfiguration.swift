//
//  TrackerMisconfiguration.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/29/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

public enum TrackerMisconfiguration : Error {
    case deviceIdMustNotBeNilOrEmpty
    case externalUserIdMustNotBeNilOrEmpty
    case breadcrumbApiKeyMustNotBeNilOrEmpty
}
