import SwiftUI
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    @Published var recordings = [Recording]()
    @Published var recordingSaved = false
    @Published var fakeCallHistory = [CallHistoryItem]()
    @Published var uploadProgress: Double = 0.0
    @Published var isUploading = false
    @Published var uploadSuccess = false
    @Published var uploadError: String?

    override init() {
        super.init()
        loadRecordings()
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording-\(Date().timeIntervalSince1970).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            isRecording = true
            print("Recording started at: \(audioFilename.path)")
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        guard let audioRecorder = audioRecorder else {
            return
        }

        audioRecorder.stop()
        let recordedURL = audioRecorder.url
        self.audioRecorder = nil

        isRecording = false

        if success {
            print("Recording finished at: \(recordedURL.path)")
            if FileManager.default.fileExists(atPath: recordedURL.path) {
                print("File exists at path: \(recordedURL.path)")
                loadRecordings()
                recordingSaved = true // Notify that the recording is saved
                uploadRecording(fileURL: recordedURL)
            } else {
                print("File does not exist at path: \(recordedURL.path)")
            }
        } else {
            print("Recording failed")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadRecordings() {
        recordings.removeAll()

        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs {
                let recording = Recording(fileURL: url)
                recordings.append(recording)
            }
        } catch {
            print("Error while enumerating files: \(error.localizedDescription)")
        }
    }

    func deleteRecording(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            loadRecordings()
        } catch {
            print("Error deleting recording: \(error.localizedDescription)")
        }
    }

    func uploadRecording(fileURL: URL) {
        let phoneNum = "0900000000" // Example phone number, you should replace this with actual user input
        let recordTime = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)

        isUploading = true
        NetworkManager.shared.uploadRecording(fileURL: fileURL, phoneNum: phoneNum, recordTime: recordTime) { result in
            DispatchQueue.main.async {
                self.isUploading = false
                switch result {
                case .success(let response):
                    print("Upload successful: \(response)")
                    self.uploadSuccess = true
                case .failure(let error):
                    print("Upload failed: \(error)")
                    self.uploadError = error.localizedDescription
                }
            }
        }
    }
    
    // Sample data for preview
    static func sampleData() -> AudioRecorder {
        let recorder = AudioRecorder()
        let sampleURL = URL(string: "https://www.example.com/sample.m4a")!
        let sampleCallHistoryItem = CallHistoryItem(
            id: UUID(),
            dateTime: "2024-05-20 11:23",
            phoneNumber: "+886 912345678",
            analysis: CallAnalysis(
                fraudProbability: 83,
                detectedKeywords: ["Money", "Bank", "Account"],
                suggestions: ["Stay calm and alert.", "Do not disclose any personal information.", "Report the scam to local authorities."]
            ),
            recordingURL: sampleURL
        )
        recorder.fakeCallHistory.append(sampleCallHistoryItem)
        return recorder
    }
}

struct Recording: Identifiable {
    let id = UUID()
    let fileURL: URL

    var fileName: String {
        fileURL.lastPathComponent
    }
}

struct CallHistoryItem: Identifiable {
    let id: UUID
    let dateTime: String
    let phoneNumber: String
    let analysis: CallAnalysis
    let recordingURL: URL
}

struct CallAnalysis {
    let fraudProbability: Int
    let detectedKeywords: [String]
    let suggestions: [String]
}
