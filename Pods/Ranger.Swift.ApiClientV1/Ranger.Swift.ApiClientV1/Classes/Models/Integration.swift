//
//  Integration.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

import Foundation

public struct Integration: Codable {
    public init(id: UUID, type: IntegrationTypes, name: String, description: String, projectId: UUID) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.projectId = projectId
    }
    
    public private(set) var id: UUID
    public private(set) var type: IntegrationTypes
    public private(set) var name: String
    public private(set) var description: String
    public private(set) var projectId: UUID
}
