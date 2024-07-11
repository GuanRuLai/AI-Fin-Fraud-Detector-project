import SwiftUI
import AVKit

struct AnalysisResultsView: View {
    @Environment(\.presentationMode) var presentationMode  // To handle the dismiss action
    @State private var isPlaying = false
    @State private var playbackProgress: Double = 0.0
    @State private var player: AVPlayer
    @State private var playerObserver: Any?
    @State private var playerDuration: CMTime = CMTime.zero

    let callDateTime: String
    let callerName: String
    let callerPhoneNumber: String
    let fraudProbability: Int
    let detectedKeywords: [String]
    let suggestions: [String]
    let recordingURL: URL

    init(callDateTime: String, callerName: String, callerPhoneNumber: String, fraudProbability: Int, detectedKeywords: [String], suggestions: [String], recordingURL: URL) {
        self.callDateTime = callDateTime
        self.callerName = callerName
        self.callerPhoneNumber = callerPhoneNumber
        self.fraudProbability = fraudProbability
        self.detectedKeywords = detectedKeywords
        self.suggestions = suggestions
        self.recordingURL = recordingURL
        self._player = State(initialValue: AVPlayer(url: recordingURL))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {  // Increase the spacing between sections
            HStack {
                Button(action: {
                    // Back action: Dismiss the current view
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                Spacer()
                Button(action: {
                    // Done action: Dismiss the current view
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            VStack {
                Text(callDateTime)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text(callerName)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text(callerPhoneNumber)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The")
                                .font(.title2)
                            Text("Scam Probability")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("of this phone call is ...")
                                .font(.title2)
                        }
                        .frame(width: geometry.size.width * 0.75, alignment: .leading)
                        
                        Text("\(fraudProbability)%")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(fraudProbability > 70 ? .red : .primary)
                            .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                    }
                }
                .frame(height: 80)
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Key Words")
                    .font(.title2)
                    .padding(.horizontal)
                
                Text("• " + detectedKeywords.joined(separator: ", "))
                    .font(.body)
                    .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("What Can You Do")
                    .font(.title2)
                    .padding(.horizontal)
                
                ForEach(suggestions.indices, id: \.self) { index in
                    Text("\(index + 1). \(suggestions[index])")
                        .font(.body)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Call Recording Player
            VStack {
                Text("Call Recording")
                    .font(.title2)
                    .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        if self.isPlaying {
                            self.player.pause()
                        } else {
                            self.player.play()
                        }
                        self.isPlaying.toggle()
                    }) {
                        Image(systemName: self.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        self.player.pause()
                        self.player.seek(to: .zero)
                        self.isPlaying = false
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                }
                
                Slider(value: $playbackProgress, in: 0...1, onEditingChanged: sliderEditingChanged)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                setupPlayerObserver()
            }
            .onDisappear {
                removePlayerObserver()
            }
        }
        .padding()
        .navigationBarHidden(true)
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted == false {
            let targetTime = CMTime(seconds: Double(playbackProgress) * playerDuration.seconds, preferredTimescale: 600)
            player.seek(to: targetTime)
        }
    }
    
    private func setupPlayerObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        playerObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            self.playbackProgress = player.currentTime().seconds / playerDuration.seconds
        }
        playerDuration = player.currentItem?.asset.duration ?? CMTime.zero
    }
    
    private func removePlayerObserver() {
        if let observer = playerObserver {
            player.removeTimeObserver(observer)
            playerObserver = nil
        }
    }
}

struct AnalysisResultsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisResultsView(
            callDateTime: "2024-5-20 11:23",
            callerName: "Unknown",
            callerPhoneNumber: "+886 912 345 678",
            fraudProbability: 83,
            detectedKeywords: ["Money", "Bank", "Account", "Credit"],
            suggestions: [
                "Stay calm and alert.",
                "Do not disclose any personal information.",
                "Report the scam to local authorities."
            ],
            recordingURL: URL(string: "https://www.example.com/recording.mp3")!
        )
    }
}
