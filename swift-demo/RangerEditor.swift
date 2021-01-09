//
//  ProfileEditor.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI
import Combine

struct RangerEditor: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @Binding var rangerConfig: RangerConfig
    @Binding var pusherConfig: PusherConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ranger Tracker Configuration").bold().foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Breadcrumb API Key").bold()
                    TextField("Breadcrumb API Key", text: $rangerConfig.breadcrumbApiKey).autocapitalization(.none).disableAutocorrection(true)
                }
                VStack(alignment: .leading) {
                    Text("External User Id").bold()
                    TextField("External User Id", text: $rangerConfig.externalUserId).autocapitalization(.none).disableAutocorrection(true)
                }
                VStack(alignment: .leading) {
                    Text("Distance Filter").bold()
                    TextField("Distance Filter", text: $rangerConfig.distanceFilter)
                        .keyboardType(UIKeyboardType.decimalPad)
                        .onReceive(Just(rangerConfig.distanceFilter)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.rangerConfig.distanceFilter = filtered
                            }
                        }.autocapitalization(.none).disableAutocorrection(true)
                }
                Text("Pusher Integration Configuration").bold().foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Key").bold()
                    TextField("Key", text: $pusherConfig.pusherKey).autocapitalization(.none).disableAutocorrection(true)
                }
                VStack(alignment: .leading) {
                    Text("Cluster").bold()
                    TextField("Cluster", text: $pusherConfig.pusherCluster).autocapitalization(.none).disableAutocorrection(true)
                }
                Spacer()
            }
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RangerEditor_Previews: PreviewProvider {
    static var previews: some View {
        RangerEditor(rangerConfig: .constant(RangerConfig()), pusherConfig: .constant(PusherConfig()))
    }
}
