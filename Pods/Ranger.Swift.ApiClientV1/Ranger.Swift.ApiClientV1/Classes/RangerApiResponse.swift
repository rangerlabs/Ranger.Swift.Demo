//
//  RangerApiResponse.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

public struct RangerApiResponse<T:Codable>: Codable {
    var statusCode: Int
    var message: String?
    @DecodableDefault.False var isError: Bool
    var error: RangerApiError?
    var result: T?
}

public struct RangerApiError: Codable {
    var message: String?
    var validationErrors: [ValidationError]?
}

public struct ValidationError: Codable {
    var name: String?
    var reason: String?
}
