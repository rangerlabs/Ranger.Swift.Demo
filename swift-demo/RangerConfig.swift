/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores user profile data.
*/

import Foundation

enum RangerConfigKeys: String {
    case breadcrumbApiKey = "breadcrumbApiKey"
    case externalUserId = "externalUserId"
    case distanceFilter = "distanceFilter"
}

class RangerConfig: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(breadcrumbApiKey, forKey: RangerConfigKeys.breadcrumbApiKey.rawValue)
        coder.encode(externalUserId, forKey: RangerConfigKeys.externalUserId.rawValue)
        coder.encode(distanceFilter, forKey: RangerConfigKeys.distanceFilter.rawValue)
    }
    
    required init?(coder: NSCoder) {
        breadcrumbApiKey = coder.decodeObject(forKey: RangerConfigKeys.breadcrumbApiKey.rawValue) as? String ?? "test."
        externalUserId = coder.decodeObject(forKey: RangerConfigKeys.externalUserId.rawValue) as? String ?? ""
        distanceFilter = coder.decodeObject(forKey: RangerConfigKeys.distanceFilter.rawValue) as? String ?? "100"
    }
    
    override init() {
        breadcrumbApiKey = "test."
        externalUserId = ""
        distanceFilter = "100"
    }
    
    public var breadcrumbApiKey: String
    public var externalUserId: String
    public var distanceFilter: String
}
