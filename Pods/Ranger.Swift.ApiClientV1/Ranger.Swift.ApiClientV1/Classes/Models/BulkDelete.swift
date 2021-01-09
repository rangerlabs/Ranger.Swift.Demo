//
//  BulkDelete.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

import Foundation

public struct BulkDelete: Codable {
    public init(externalIds: [String]) throws {
        if (externalIds.isEmpty) {
            throw BulkDeleteErrors.externalIdsRequired
        }
        self.externalIds = externalIds
    }
    
    public let externalIds: [String]
}

public enum BulkDeleteErrors: Error {
    case externalIdsRequired
}
