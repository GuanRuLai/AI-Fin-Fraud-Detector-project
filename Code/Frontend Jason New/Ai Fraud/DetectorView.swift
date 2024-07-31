import SwiftUI

struct DetectorView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var recordingInProgress = false
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 40) {
            Text("AI Fraud Detector")
                .font(.largeTitle)
                .padding(.top, 40)

            Button(action: {
                if recordingInProgress {
                    audioRecorder.finishRecording(success: true)
                    showAlert = true
                } else {
                    audioRecorder.startRecording()
                }
                recordingInProgress.toggle()
            }) {
                Text(recordingInProgress ? "Stop Recording" : "Start Recording")
                    .font(.title2)
                    .padding()
                    .background(recordingInProgress ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(audioRecorder.uploadSuccess ? "Recording Saved and Uploaded" : "Recording Saved"),
                    message: Text(audioRecorder.uploadError ?? "Your recording has been saved and added to the history."),
                    dismissButton: .default(Text("OK"))
                )
            }

            if audioRecorder.isUploading {
                ProgressView("Uploading...")
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct DetectorView_Previews: PreviewProvider {
    static var previews: some View {
        DetectorView(audioRecorder: AudioRecorder.sampleData())
    }
}
