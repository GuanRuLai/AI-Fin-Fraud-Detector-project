import SwiftUI

struct DetectorView: View {
    @State private var isRecording = false
    @State private var analysisResult: String = ""

    var body: some View {
        NavigationView {
            VStack {
                if isRecording {
                    Text("Recording...")
                        .foregroundColor(.red)
                } else {
                    Text("Press to start recording")
                }
                Button(action: {
                    // Toggle recording state
                    isRecording.toggle()
                    // Simulate analysis result after stopping recording
                    if !isRecording {
                        analysisResult = "This call is likely a fraud!"
                    } else {
                        analysisResult = ""
                    }
                }) {
                    Text(isRecording ? "Stop" : "Start")
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Text(analysisResult)
                    .padding()
            }
            .padding()
            .navigationTitle("Detector")
        }
    }
}

struct DetectorView_Previews: PreviewProvider {
    static var previews: some View {
        DetectorView()
    }
}
