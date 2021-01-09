//
//  ProfileHost.swift
//  swift-demo
//
//  Created by Nicholas Cromwell  on 9/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct RangerConfigHost: View {
    @Environment(\.editMode) var mode
    @EnvironmentObject var rangerData: RangerConfigObservable
    @State var draftProfile = RangerConfig.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                   Button("Cancel") {
                    self.draftProfile = self.rangerData.ranger
                       self.mode?.animation().wrappedValue = .inactive
                   }
               }
                Spacer()
                EditButton()
            }
            if self.mode?.wrappedValue == .inactive {
                RangerSummary(ranger: rangerData.ranger)
            } else {
                RangerEditor(confg: $draftProfile)
                .onAppear {
                    self.draftProfile = self.rangerData.ranger
                }
                .onDisappear {
                    self.rangerData.ranger = self.draftProfile
                }
            }
        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        RangerConfigHost().environmentObject(RangerConfigObservable())
    }
}
