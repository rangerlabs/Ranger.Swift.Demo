//
//  ProfileSummary.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct ConfigSummary: View {
    var rangerConfig: RangerConfig
    var pusherConfig: PusherConfig

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Ranger Tracker Configuration").bold().foregroundColor(.green)
                }
                VStack(alignment: .leading) {
                    Text("Breadcrumb API Key").bold()
                    Text(rangerConfig.breadcrumbApiKey)
                }
                VStack(alignment: .leading) {
                    Text("External User Id").bold()
                    Text(rangerConfig.externalUserId)
                }
                VStack(alignment: .leading) {
                    Text("Distance Filter").bold()
                    Text(String(rangerConfig.distanceFilter))
                }
                VStack(alignment: .leading) {
                    Text("Pusher Integration Configuration").bold().foregroundColor(.green)
                }
                VStack(alignment: .leading) {
                    Text("Key").bold()
                    Text(pusherConfig.pusherKey)
                }
                VStack(alignment: .leading) {
                    Text("Cluster").bold()
                    Text(pusherConfig.pusherCluster)
                }
                Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct ConfigSummary_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSummary(rangerConfig: RangerConfig(), pusherConfig: PusherConfig())
    }
}
