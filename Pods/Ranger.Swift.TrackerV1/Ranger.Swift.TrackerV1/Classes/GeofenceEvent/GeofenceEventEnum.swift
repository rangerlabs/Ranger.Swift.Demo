//
//  GeofenceEventEnum.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 10/10/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

public enum GeofenceEventEnum: String, Codable {
    case entered = "ENTERED"
    case dwelling = "DWELLING"
    case exited = "EXITED"
}
