import SwiftUI
import AVKit

struct HistoryView: View {
    @State private var showAnalysis = false
    @State private var selectedItem: CallHistoryItem?
    @State private var showAlert = false
    @State private var isLoading = false
    @ObservedObject var audioRecorder: AudioRecorder

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(audioRecorder.fakeCallHistory.indices, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(audioRecorder.fakeCallHistory[index].dateTime)
                                    .font(.headline)
                                Text("Phone: \(audioRecorder.fakeCallHistory[index].phoneNumber)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack {
                                Button(action: {
                                    self.selectedItem = audioRecorder.fakeCallHistory[index]
                                    self.isLoading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.isLoading = false
                                        self.showAnalysis.toggle()
                                    }
                                }) {
                                    Text("Analyze")
                                        .font(.caption)
                                        .frame(width: 70, height: 30)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                                Spacer(minLength: 10)
                                Button(action: {
                                    self.selectedItem = audioRecorder.fakeCallHistory[index]
                                    self.showAlert = true
                                }) {
                                    Text("Delete")
                                        .font(.caption)
                                        .frame(width: 70, height: 30)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Delete Call History"),
                                        message: Text("Are you sure you want to delete this call history?"),
                                        primaryButton: .destructive(Text("Delete")) {
                                            if let selectedItem = selectedItem {
                                                audioRecorder.fakeCallHistory.removeAll { $0.id == selectedItem.id }
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            Spacer()
                            Button(action: {
                                print("Listen Audio button clicked")
                                self.playRecording(url: audioRecorder.fakeCallHistory[index].recordingURL)
                            }) {
                                Text("Listen Audio")
                                    .font(.caption)
                                    .frame(width: 100, height: 30)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("")
                .sheet(isPresented: $showAnalysis) {
                    if let selectedItem = selectedItem {
                        AnalysisResultsView(
                            callDateTime: selectedItem.dateTime,
                            callerPhoneNumber: selectedItem.phoneNumber,
                            fraudProbability: selectedItem.analysis.fraudProbability,
                            detectedKeywords: selectedItem.analysis.detectedKeywords,
                            suggestions: selectedItem.analysis.suggestions,
                            recordingURL: selectedItem.recordingURL
                        )
                    }
                }
                
                if isLoading {
                    ProgressView("Loading Analysis...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }

    func playRecording(url: URL) {
        print("playRecording called with URL: \(url.path)")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            print("File exists at path: \(url.path)")
        } else {
            print("File does not exist at path: \(url.path)")
            return
        }

        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(playerViewController, animated: true, completion: {
                player.play()
                print("Playback started")
            })
        } else {
            print("Root view controller not found")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(audioRecorder: AudioRecorder.sampleData())
    }
}
