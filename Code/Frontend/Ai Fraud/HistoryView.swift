import SwiftUI

struct HistoryView: View {
    @State private var history = fakeCallHistory
    @State private var showAnalysis = false
    @State private var selectedItem: CallHistoryItem?
    @State private var showAlert = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(history.indices, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(history[index].dateTime)
                                    .font(.headline)
                                Text("Caller: \(history[index].callerName)")
                                    .font(.subheadline)
                                Text("Phone: \(history[index].phoneNumber)")
                                    .font(.subheadline)
                                Text("Fraud Probability: \(history[index].fraudProbability)")
                                    .font(.subheadline)
                                    .foregroundColor(history[index].fraudProbability == "90%" || history[index].fraudProbability == "80%" ? .red : .primary)
                            }
                            Spacer()
                            VStack {
                                Button(action: {
                                    self.selectedItem = history[index]
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
                                .sheet(isPresented: $showAnalysis) {
                                    if let selectedItem = selectedItem {
                                        AnalysisResultsView(
                                            callDateTime: selectedItem.dateTime,
                                            callerName: selectedItem.callerName,
                                            callerPhoneNumber: selectedItem.phoneNumber,
                                            fraudProbability: selectedItem.analysis.fraudProbability,
                                            detectedKeywords: selectedItem.analysis.detectedKeywords,
                                            suggestions: selectedItem.analysis.suggestions,
                                            recordingURL: URL(string: "https://www.example.com/recording.mp3")! // Replace with actual recording URL
                                        )
                                    }
                                }
                                Spacer(minLength: 10)
                                Button(action: {
                                    self.selectedItem = history[index]
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
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Delete Call History"),
                                        message: Text("Are you sure you want to delete this call history?"),
                                        primaryButton: .destructive(Text("Delete")) {
                                            if let selectedItem = selectedItem {
                                                history.removeAll { $0.id == selectedItem.id }
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                    }
                }
                .navigationTitle("History")
                
                if isLoading {
                    ProgressView("Loading Analysis...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
