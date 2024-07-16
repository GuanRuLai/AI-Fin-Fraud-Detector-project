import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AI_Fin_Fraud_DetectorApp: App {
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
            } else {
                ActivationView(isActive: $isActive)
            }
        }
    }
}
