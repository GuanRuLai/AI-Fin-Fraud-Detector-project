import SwiftUI

struct NotificationView: View {
    @State private var selectedTab = 0
    @State private var officialNotifications = [
        "System maintenance on July 3",
        "New features added"
    ]
    @State private var contactNotifications = [
        "John Doe sent you a message",
        "Jane Smith commented on your post"
    ]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Notifications", selection: $selectedTab) {
                    Text("Official").tag(0)
                    Text("Contacts").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    List(officialNotifications, id: \.self) { notification in
                        Text(notification)
                    }
                } else {
                    List(contactNotifications, id: \.self) { notification in
                        Text(notification)
                    }
                }
            }
            .navigationTitle("Notifications")
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
