import SwiftUI

struct ActivationView: View {
    @Binding var isActive: Bool

    var body: some View {
        VStack {
            Text("AI Fraud Detector")
                .font(.largeTitle)
                .padding()
            Button(action: {
                isActive = true
            }) {
                Text("Start Detecting")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct ActivationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivationView(isActive: .constant(false))
    }
}
