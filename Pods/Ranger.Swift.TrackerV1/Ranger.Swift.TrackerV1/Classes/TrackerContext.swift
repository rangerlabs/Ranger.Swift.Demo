//
//  Location.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreLocation
import Ranger_Swift_ApiClientV1

public struct TrackerContext {
    public static let `default` = Self(isTracking: false, isPaused: false, desiredAccuracy: Int(kCLLocationAccuracyBest), distanceFilter: Int(kCLDistanceFilterNone),  externalUserId: "", breadcrumbMetadata: [], trackingMethod: TrackingMethod.NotTracking, lastPosition: CLLocationCoordinate2D(), date: Date.init())
    
    public var isTracking: Bool
    public var isPaused: Bool
    public var desiredAccuracy: Int
    public var distanceFilter: Int
    public var externalUserId: String
    public var breadcrumbMetadata: [KeyValuePair]
    public var trackingMethod: TrackingMethod
    public var lastPosition: CLLocationCoordinate2D
    public var date: Date
}

