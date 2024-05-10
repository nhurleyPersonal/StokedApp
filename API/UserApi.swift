import Foundation

class UserAPI {
    static let shared = UserAPI()

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://localhost:3000/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": username, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                if let jwt = String(data: data, encoding: .utf8) {
                    print("JWT: \(jwt)")
                    completion(true)
                } else {
                    completion(false)
                }
            } else if let error = error {
                print("Error: \(error)")
                completion(false)
            }
        }.resume()
    }

    func register(email: String, firstName: String, lastName: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://your-backend-url.com/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "firstName": firstName, "lastName": lastName, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
                completion(true)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(false)
            }
        }.resume()
    }
}
