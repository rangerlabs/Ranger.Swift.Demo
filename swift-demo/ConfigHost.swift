//
//  ProfileHost.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct ConfigHost: View {
    var rangerConfig: RangerConfig
    var pusherConfig: PusherConfig
    @Environment(\.editMode) var mode
    @State var draftRangerProfile = RangerConfig()
    @State var draftPusherProfile = PusherConfig()
    
    init() {
        let defaults = UserDefaults.standard
        let storedRangerConfig = defaults.object(forKey: "RangerConfig") as? Data
        let storedPusherConfig = defaults.object(forKey: "PusherConfig") as? Data
        
        rangerConfig = RangerConfig()
        if (storedRangerConfig != nil) {
            do {
                rangerConfig = try NSKeyedUnarchiver.unarchivedObject(ofClass: RangerConfig.self, from: storedRangerConfig!)!
            } catch {
                print("No saved Ranger Configuration, using default")
            }
        }
        
        pusherConfig = PusherConfig()
        if (storedPusherConfig != nil) {
            do {
                pusherConfig = try NSKeyedUnarchiver.unarchivedObject(ofClass: PusherConfig.self, from: storedPusherConfig!)!
            } catch {
                print("No saved Pusher Configuration, using default")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                   Button("Cancel") {
                        self.draftRangerProfile = self.rangerConfig
                        self.draftPusherProfile = self.pusherConfig
                        self.mode?.animation().wrappedValue = .inactive
                   }
               }
                Spacer()
                EditButton()
            }
            if self.mode?.wrappedValue == .inactive {
                ConfigSummary(rangerConfig: rangerConfig, pusherConfig: pusherConfig)
            } else {
                RangerEditor(rangerConfig: $draftRangerProfile, pusherConfig: $draftPusherProfile)
                .onAppear {
                    self.draftRangerProfile = self.rangerConfig
                    self.draftPusherProfile = self.pusherConfig
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    let defaults = UserDefaults.standard
                    do {
                        let encodedRangerData = try NSKeyedArchiver.archivedData(withRootObject: self.rangerConfig, requiringSecureCoding: false)
                        let encodedPusherData = try NSKeyedArchiver.archivedData(withRootObject: self.pusherConfig, requiringSecureCoding: false)
                        defaults.set(encodedRangerData, forKey: "RangerConfig")
                        defaults.set(encodedPusherData, forKey: "PusherConfig")
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .padding()
    }
}

struct ConfigHost_Previews: PreviewProvider {
    static var previews: some View {
        ConfigHost()
    }
}
