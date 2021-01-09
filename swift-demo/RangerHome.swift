import SwiftUI
import CoreLocation
import Ranger_Swift_TrackerV1

struct RangerHome: View {
    @State var showingProfile = false
    @State var pusherConfigured = false
    @State var lastEvent: GeofenceEvent?
    @EnvironmentObject var rangerTracker: RangerTrackerV1

    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "gear")
                .imageScale(.large)
                .accessibility(label: Text("Settings"))
                .foregroundColor(Color.gray)
                .padding()
        }
    }
    
    fileprivate func initializePusher(_ storedPusherConfig: Data?) throws {
        var retrievedPusherConfig = PusherConfig()
        if (storedPusherConfig != nil) {
            do {
                retrievedPusherConfig = try NSKeyedUnarchiver.unarchivedObject(ofClass: PusherConfig.self, from: storedPusherConfig!)!
            } catch {
                print("No saved Pusher Configuration, using default")
            }
        }
       if (!retrievedPusherConfig.pusherKey.isEmpty && !retrievedPusherConfig.pusherCluster.isEmpty) {
        PusherNotifier.pusherConnect(pusherKey: retrievedPusherConfig.pusherKey, cluster: retrievedPusherConfig.pusherCluster) { geofenceEvent in
                self.lastEvent = geofenceEvent
            }
            self.pusherConfigured = true
        }
    }
    
    fileprivate func initializeRangerTracker(_ storedRangerConfig: Data?, _ deviceId: String) throws {
        var retrievedRangerConfig = RangerConfig()
        if (storedRangerConfig != nil) {
            do {
                retrievedRangerConfig = try NSKeyedUnarchiver.unarchivedObject(ofClass: RangerConfig.self, from: storedRangerConfig!)!
            } catch {
                print("No saved Ranger Configuration, using default")
            }
        }

        try RangerTrackerV1.configure(deviceId: deviceId, breadcrumbApiKey: retrievedRangerConfig.breadcrumbApiKey)
        RangerTrackerV1.requestWhenInUseAuthorization()
        RangerTrackerV1.trackStandardLocation(distanceFilter: CLLocationDistance(Int(retrievedRangerConfig.distanceFilter) ?? 0))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                if (self.pusherConfigured) {
                    Text("Last Event")
                    Text("\(self.lastEvent?.events[0].geofenceEvent.rawValue ?? "")")
                    Text("\(self.lastEvent?.events[0].geofenceExternalId ?? "")")
                } else {
                    Text("Configure the Pusher Integration to receive live geofence events.").multilineTextAlignment(.center)
                }
                Spacer()
                Button(action: {
                    if (self.rangerTracker.context.isTracking) {
                        RangerTrackerV1.stopTracking()
                    }
                    else {
                        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
                            print("No device id could be obtained")
                            return
                        }
                        let defaults = UserDefaults.standard
                        let storedRangerConfig = defaults.object(forKey: "RangerConfig") as? Data
                        let storedPusherConfig = defaults.object(forKey: "PusherConfig") as? Data

                        do {
                            try self.initializeRangerTracker(storedRangerConfig, deviceId)
                            try self.initializePusher(storedPusherConfig)
                       } catch {
                            print(error)
                        }
                    }
                }) {
                    Text(self.rangerTracker.context.isTracking ? "Stop Tracking" : "Start Tracking")
                        .multilineTextAlignment(TextAlignment.center)
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color.white)
                        .background(RangerTrackerV1.instance.context.isTracking ? Color.red : Color.green)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Distance Filter: \(RangerTrackerV1.instance.context.distanceFilter)")
                Text("Lat: \(RangerTrackerV1.instance.context.lastPosition.longitude)")
                Text("Lng: \(RangerTrackerV1.instance.context.lastPosition.latitude)")
            }
            .navigationBarTitle(Text("Ranger Labs"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                ConfigHost()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RangerHome_Previews: PreviewProvider {
    static var previews: some View {
        let locationObservable = TrackerContextObservable()
        return RangerHome().environmentObject(locationObservable)
    }
}
