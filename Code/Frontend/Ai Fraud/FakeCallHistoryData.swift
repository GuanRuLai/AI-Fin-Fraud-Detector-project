import Foundation

struct CallHistoryItem: Identifiable {
    let id = UUID()
    var dateTime: String
    var callerName: String
    var phoneNumber: String
    var fraudProbability: String
    var analysis: AnalysisResult
}

struct AnalysisResult {
    var fraudProbability: Int
    var detectedKeywords: [String]
    var suggestions: [String]
}

let fakeCallHistory = [
    CallHistoryItem(
        dateTime: "2024-07-01 10:15 AM",
        callerName: "John Doe",
        phoneNumber: "+886 912 345 678",
        fraudProbability: "90%",
        analysis: AnalysisResult(
            fraudProbability: 90,
            detectedKeywords: ["investment", "guaranteed", "urgent", "transfer", "account"],
            suggestions: [
                "Hang up the call immediately.",
                "Do not share any personal or financial information.",
                "Report the number to your local authorities."
            ]
        )
    ),
    CallHistoryItem(
        dateTime: "2024-06-30 02:45 PM",
        callerName: "Unknown",
        phoneNumber: "+886 912 234 567",
        fraudProbability: "60%",
        analysis: AnalysisResult(
            fraudProbability: 60,
            detectedKeywords: ["offer", "free", "urgent", "transfer"],
            suggestions: [
                "Be cautious and verify the offer.",
                "Do not share any personal or financial information.",
                "Block the number if suspicious."
            ]
        )
    ),
    CallHistoryItem(
        dateTime: "2024-06-29 11:30 AM",
        callerName: "Alice Chen",
        phoneNumber: "+886 912 345 789",
        fraudProbability: "30%",
        analysis: AnalysisResult(
            fraudProbability: 30,
            detectedKeywords: ["information", "account", "verify"],
            suggestions: [
                "Verify the caller's identity.",
                "Do not provide sensitive information.",
                "Monitor your accounts for suspicious activity."
            ]
        )
    ),
    CallHistoryItem(
        dateTime: "2024-06-28 04:10 PM",
        callerName: "Unknown",
        phoneNumber: "+886 912 456 890",
        fraudProbability: "80%",
        analysis: AnalysisResult(
            fraudProbability: 80,
            detectedKeywords: ["urgent", "immediate", "transfer", "account"],
            suggestions: [
                "Hang up if the call seems suspicious.",
                "Never provide personal or financial information over the phone.",
                "Report the call to your bank or financial institution."
            ]
        )
    )
]
