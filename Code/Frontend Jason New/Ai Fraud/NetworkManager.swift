import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://192.168.x.x:8000/api" // Replace with your local IP address

    private init() {}

    func uploadRecording(fileURL: URL, phoneNum: String, recordTime: String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        let uploadURL = URL(string: "\(baseURL)/upload")!
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add file data
        if let fileData = try? Data(contentsOf: fileURL) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
            data.append(fileData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        // Add phone number
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"phone_num\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(phoneNum)\r\n".data(using: .utf8)!)
        
        // Add record time
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"record_time\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(recordTime)\r\n".data(using: .utf8)!)
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
                completion(.success(uploadResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct UploadResponse: Decodable {
    let audioURL: String
    let textFileURL: String
    let recordText: String
}
