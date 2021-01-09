//
//  KeyValuePair.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

import Foundation

public struct KeyValuePair: Codable {
    public init(key: String, value: String) throws {
        if (key.isEmpty) {
            throw KeyValuePairErrors.keyRequired
        }
        if (value.isEmpty) {
            throw KeyValuePairErrors.valueRequired
        }
        self.key = key
        self.value = value
    }
    public var key: String
    public var value: String
}

public enum KeyValuePairErrors: Error {
    case keyRequired
    case valueRequired
}
