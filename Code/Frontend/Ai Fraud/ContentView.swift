import SwiftUI

struct ContentView: View {
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            TabView {
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
                
                DetectorView()
                    .tabItem {
                        Label("Detector", systemImage: "mic")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
