//
//  PusherConfig.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 12/5/20.
//  Copyright © 2020 RangerLabs. All rights reserved.
//

import Foundation

enum PusherConfigKeys: String {
    case pusherKey = "pusherKey"
    case pusherCluster = "pusherCluster"
}

class PusherConfig: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(pusherKey, forKey: PusherConfigKeys.pusherKey.rawValue)
        coder.encode(pusherCluster, forKey: PusherConfigKeys.pusherCluster.rawValue)
    }
    
    required init?(coder: NSCoder) {
        pusherKey = coder.decodeObject(forKey: PusherConfigKeys.pusherKey.rawValue) as? String ?? ""
        pusherCluster = coder.decodeObject(forKey: PusherConfigKeys.pusherCluster.rawValue) as? String ?? ""
    }
    
    override init() {
        pusherKey = ""
        pusherCluster = ""
    }
    
    public var pusherKey: String
    public var pusherCluster: String
}
