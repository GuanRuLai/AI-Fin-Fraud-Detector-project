import SwiftUI

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
