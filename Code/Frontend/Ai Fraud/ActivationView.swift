import SwiftUI

struct ActivationView: View {
    @Binding var isActive: Bool
    @State private var username: String = ""
    @State private var receivedUsername: String = ""

    var body: some View {
        VStack {
            Text("AI Fraud Detector")
                .font(.largeTitle)
                .padding()

            TextField("Enter your username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                sendData()
            }) {
                Text("Start Detecting")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if !receivedUsername.isEmpty {
                Text("Received: \(receivedUsername)")
                    .padding()
            }
        }
    }

    func sendData() {
        guard let url = URL(string: "http://localhost:8000/api/test") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["name": username]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        // 更新接收到的用户名并激活界面
                        self.receivedUsername = decodedResponse.username
                        //self.isActive = true
                    }
                } else {
                    print("Invalid response from server")
                }
            }
        }.resume()
    }
}

struct Response: Codable {
    var username: String
}

struct ActivationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivationView(isActive: .constant(false))
    }
}
