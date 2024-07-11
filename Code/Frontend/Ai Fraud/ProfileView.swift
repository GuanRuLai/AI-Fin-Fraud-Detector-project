import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Placeholder for profile information
                Text("User Profile")
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
