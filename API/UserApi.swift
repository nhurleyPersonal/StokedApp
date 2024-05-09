//import Foundation
//
//struct LoginData: Codable {
//    let username: String
//    let password: String
//}
//
//func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
//    guard let url = URL(string: "http://localhost:5000/login") else {
//        print("Invalid URL")
//        return
//    }
//
//    let loginData = LoginData(username: username, password: password)
//    guard let encodedLoginData = try? JSONEncoder().encode(loginData) else {
//        print("Failed to encode login data")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.httpBody = encodedLoginData
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let data = data {
//            if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
//                DispatchQueue.main.async {
//                    completion(decodedResponse.success)
//                }
//                return
//            }
//        }
//        print("Login request failed: \(error?.localizedDescription ?? "Unknown error")")
//    }.resume()
//}
