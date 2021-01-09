//
//  GeofenceEvent.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 10/10/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

import Foundation
import Ranger_Swift_ApiClientV1

public struct GeofenceEvent: Codable {
    public let id: UUID
    public let project: String
    public let environment: EnvironmentEnum
    public let breadcrumb: Breadcrumb
    public let events: [Event]
    public let integrationMetadata: [KeyValuePair]?
}

public struct Event: Codable {
    public let geofenceId: UUID
    public let geofenceExternalId: String
    public let geofenceDescription: String?
    public let geofenceMetadata: [KeyValuePair]?
    public let geofenceEvent: GeofenceEventEnum
}
