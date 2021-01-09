//
//  Geofence.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

import Foundation

public struct Geofence: Codable {
    public init(id: UUID? = nil, externalId: String, shape: GeofenceShapes, coordinates: [LatLng], radius: Int? = nil, projectId: UUID? = nil, description: String? = nil, integrationIds: [UUID] = [], metadata: [KeyValuePair] = [], onEnter: Bool = true, onDwell: Bool = false, onExit: Bool = true, enabled: Bool = true, schedule: Schedule? = nil, createdDate: Date? = nil, updatedDate: Date? = nil) throws {
        if (externalId.isEmpty) {
            throw GeofenceErrors.externalIdRequired
        }
        if (shape == GeofenceShapes.Circle) {
            if (radius == nil || radius! < 100) {
                throw GeofenceErrors.radiusMustBeGreaterThanOrEqualTo100
            }
            if (coordinates.count != 1) {
                throw GeofenceErrors.coordinatesMustContainExactly1LatLng
            }
        } else {
            if (!(coordinates.count >= 3)) {
                throw GeofenceErrors.coordinatesMustContainAtLeast3LatLng
            }
        }
        self.id = id
        self.externalId = externalId
        self.shape = shape
        self.coordinates = coordinates
        self.radius = radius
        self.projectId = projectId
        self.description = description
        self.integrationIds = integrationIds
        self.metadata = metadata
        self.onEnter = onEnter
        self.onDwell = onDwell
        self.onExit = onExit
        self.enabled = enabled
        self.schedule = schedule
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    
    public private(set) var id: UUID?
    public private(set) var externalId: String
    public private(set) var shape: GeofenceShapes
    public private(set) var coordinates: [LatLng]
    public private(set) var radius: Int?
    public private(set) var projectId: UUID?
    public private(set) var description: String?
    public private(set) var integrationIds: [UUID]
    public private(set) var metadata: [KeyValuePair]
    public private(set) var onEnter: Bool
    public private(set) var onDwell: Bool
    public private(set) var onExit: Bool
    public private(set) var enabled: Bool
    public private(set) var schedule: Schedule?
    public private(set) var createdDate: Date?
    public private(set) var updatedDate: Date?
}

public enum GeofenceErrors: Error {
    case externalIdRequired
    case radiusMustBeGreaterThanOrEqualTo100
    case coordinatesMustContainExactly1LatLng
    case coordinatesMustContainAtLeast3LatLng
}
