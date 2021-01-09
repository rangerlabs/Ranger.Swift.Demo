//
//  RangerTracker.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/26/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreLocation
import Ranger_Swift_ApiClientV1

public final class RangerTrackerV1: NSObject, ObservableObject {
    private let locationManager: CLLocationManager
    static private let misconfigurationError = "Tracker misconfigured. Ensure .configure() was called."
    public static let instance = RangerTrackerV1()
    public static private(set) var deviceId: String = ""
    public static private(set) var breadcrumbApiKey: String = ""
    public static private(set) var externalUserId: String? = ""
    public static private(set) var breadcrumbMetadata: [KeyValuePair] = []
    @Published public var context = TrackerContext.default

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    public static func requestWhenInUseAuthorization() {
        instance.locationManager.requestWhenInUseAuthorization()
    }
    
    public static func requestAlwaysAuthorization() {
        instance.locationManager.requestAlwaysAuthorization()
    }
    
    public static func configure(deviceId: String, breadcrumbApiKey: String) throws {
        try TrackerConfigurationValidator.deviceIdValid(deviceId: deviceId)
        try TrackerConfigurationValidator.breadcrumbApiKeyValid(breadcrumbApiKey: breadcrumbApiKey)

        RangerTrackerV1.deviceId = deviceId
        RangerTrackerV1.breadcrumbApiKey = breadcrumbApiKey
    }
    
    public static func configure(deviceId: String, externalUserId: String, breadcrumbApiKey: String) throws {
        try TrackerConfigurationValidator.deviceIdValid(deviceId: deviceId)
        try TrackerConfigurationValidator.externalUserIdValid(externalUserId: externalUserId)
        try TrackerConfigurationValidator.breadcrumbApiKeyValid(breadcrumbApiKey: breadcrumbApiKey)

        RangerTrackerV1.deviceId = deviceId
        RangerTrackerV1.externalUserId = externalUserId
        RangerTrackerV1.breadcrumbApiKey = breadcrumbApiKey
    }
    
    public static func trackStandardLocation(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest, distanceFilter: CLLocationDistance = kCLDistanceFilterNone, pauseLocationUpdatesAutomatically: Bool = false, activityType: CLActivityType = .other) {
        if (deviceId.isEmpty) {
            print(misconfigurationError)
            return
        }
        instance.locationManager.desiredAccuracy = desiredAccuracy
        instance.locationManager.distanceFilter = distanceFilter
        instance.locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomatically
        instance.locationManager.activityType = activityType
        instance.context.isTracking = true
        instance.context.distanceFilter = Int(distanceFilter)
        instance.context.trackingMethod = TrackingMethod.StandardLocationChanges
        instance.locationManager.startUpdatingLocation()
    }
    
    public static func trackSignificantLocationChanges(pauseLocationUpdatesAutomatically: Bool = false, activityType: CLActivityType = .other) {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("Significant Location Change Monitoring is unavailable")
            return
        }
        if (deviceId.isEmpty) {
            print(misconfigurationError)
            return
        }
        instance.locationManager.pausesLocationUpdatesAutomatically = pauseLocationUpdatesAutomatically
        instance.locationManager.activityType = activityType
        instance.context.isTracking = true
        instance.context.trackingMethod = TrackingMethod.SignificantLocationChanges
        instance.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public static func allowsBackgroundLocationUpdates(allowsBackgroundLocationUpdates: Bool = true, showBackgroundLocationIndicator: Bool = false)
    {
        if (deviceId.isEmpty) {
            print(misconfigurationError)
            return
        }
        instance.locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        instance.locationManager.showsBackgroundLocationIndicator = showBackgroundLocationIndicator
    }
    
    public static func stopTracking() {
        if (deviceId.isEmpty) {
            print(misconfigurationError)
            return
        }
        switch instance.context.trackingMethod {
            case TrackingMethod.SignificantLocationChanges:
                instance.locationManager.stopMonitoringSignificantLocationChanges()
            default:
                instance.locationManager.stopUpdatingLocation()
        }
        instance.context.isTracking = false
    }
    
    public static func setExternalId(externalId: String) {
        RangerTrackerV1.externalUserId = externalUserId
        RangerTrackerV1.instance.context.externalUserId = externalUserId!
    }
    
    public static func setBreadcrumbMetadata(metadata: [KeyValuePair]) {
        RangerTrackerV1.breadcrumbMetadata = metadata
        RangerTrackerV1.instance.context.breadcrumbMetadata = metadata
    }
    
    public static func setApiBaseUrl(url: String) {
        RangerSwiftApiClientV1.SetBaseUrl(url: url)
    }
}

extension RangerTrackerV1: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.context.lastPosition = location.coordinate

        do {
            let accuracy = RangerTrackerV1.instance.context.desiredAccuracy < 0 ? 0 : RangerTrackerV1.instance.context.desiredAccuracy
            let metadata = RangerTrackerV1.breadcrumbMetadata
            let breadcrumb = try Breadcrumb(deviceId: RangerTrackerV1.deviceId, position: try LatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude ), recordedAt: Date(), accuracy: accuracy, metadata: metadata)
            try RangerSwiftApiClientV1.PostBreadcrumb(breadcrumb: breadcrumb, apiKey: RangerTrackerV1.breadcrumbApiKey) {response in
                debugPrint(response)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        self.context.isPaused = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        self.context.isPaused = false
    }
}
