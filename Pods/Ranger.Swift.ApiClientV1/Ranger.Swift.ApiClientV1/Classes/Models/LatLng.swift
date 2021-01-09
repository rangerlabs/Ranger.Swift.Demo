//
//  LatLng.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

public struct LatLng: Codable {
    public init(lat: Double, lng: Double) throws {
        if (lat < -90 || lat > 90) {
            throw LatLngErrors.latOutOfRange("lat must be between [-90, 90]")
        }
        if (lng < -180 || lng > 180) {
            throw LatLngErrors.lngOutOfRange("lng must be between [-180, 180]")
        }
        self.lat = lat
        self.lng = lng
    }
    
    public let lat: Double
    public let lng: Double
}

public enum LatLngErrors : Error {
    case latOutOfRange(String)
    case lngOutOfRange(String)
}
