import SwiftUI

struct ContentView: View {
    @StateObject var audioRecorder = AudioRecorder()

    var body: some View {
        TabView {
            HistoryView(audioRecorder: audioRecorder)
                .tabItem {
                    Label("History", systemImage: "list.dash")
                }
            DetectorView(audioRecorder: audioRecorder)
                .tabItem {
                    Label("Detector", systemImage: "mic.fill")
                }
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
