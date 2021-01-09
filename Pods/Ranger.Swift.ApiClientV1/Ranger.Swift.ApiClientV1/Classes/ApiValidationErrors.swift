//
//  ApiValidationErrors.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

public enum InvalidApiKeyError: Error {
    case mustBeLiveOrTestApiKey
    case mustBeProjectApiKey
}

public enum ApiInputError: Error {
    case externalIdRequired
    case externalIdCollectionRequired
    case pageCountOutOfBounds(String)
    case pageOutOfBounds(String)
    case idRequired
}
