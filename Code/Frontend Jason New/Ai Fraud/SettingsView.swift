import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Profile")) {
                        Text("Profile")
                    }
                    NavigationLink(destination: Text("Privacy")) {
                        Text("Privacy")
                    }
                }
                
                Section(header: Text("Notifications")) {
                    NavigationLink(destination: Text("Preferences")) {
                        Text("Preferences")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: Text("Version")) {
                        Text("Version")
                    }
                    NavigationLink(destination: Text("Contact Us")) {
                        Text("Contact Us")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
