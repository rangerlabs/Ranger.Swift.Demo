//
//  PusherNotifier.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 10/7/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

import Foundation
import PusherSwift

public class PusherNotifier: PusherDelegate {
    private static var instance = PusherNotifier()
    public static private(set) var options: PusherClientOptions? = nil
    public private(set) var deviceChannel: PusherChannel!
    public private(set) var pusher: Pusher!
    private var decoder = JSONDecoder()

    private init() {
        let isoFormatter = DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
        decoder.dateDecodingStrategy = .formatted(isoFormatter)
    }
    
    public static func pusherConnect(pusherKey: String, cluster: String, completionHandler: @escaping ((GeofenceEvent) -> Void)) {
        options = PusherClientOptions(
          host: .cluster(cluster)
        )
        instance.pusher = Pusher(key: pusherKey, options: options!)
        instance.pusher.delegate = instance

        instance.deviceChannel = instance.pusher.subscribe("ranger-\(RangerTrackerV1.deviceId)")
        instance.pusher.connect()
       
        let _ = instance.deviceChannel!.bind(eventName: "ranger-geofence-event", eventCallback: { (event: PusherEvent) in
            guard let json: String = event.data,
                let jsonData: Data = json.data(using: .utf8)
            else{
                debugPrint("Could not convert JSON string to data")
                return
            }
            print(jsonData)
            let geofenceEvent: GeofenceEvent = try! instance.decoder.decode(GeofenceEvent.self, from: jsonData)
            completionHandler(geofenceEvent)
        })
    }
    
    public func debugLog(message: String) {
        print(message)
      }
}

