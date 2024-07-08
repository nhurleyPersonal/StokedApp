import Foundation
import KeychainSwift

class UserAPI {
    static let shared = UserAPI()
    private let keychain = KeychainSwift()
    private let baseURL = "https://stoked-backend-a7f20ecf2b79.herokuapp.com/api"

    struct ServerResponse: Codable {
        let status: String
        let message: String
        let token: String?
        let user: User?
    }

    struct MeServerResponse: Codable {
        let user: User?
    }

    struct UpdateUserResponse: Codable {
        let status: String
        let message: String
        let token: String?
    }

    struct UpdateBioResponse: Codable {
        let message: String
    }

    struct UserSearchServerResponse: Codable {
        let status: String
        let message: String
        let token: String?
        let users: [User]?
    }

    struct UserRegistration: Codable {
        let user: PreAddUser
        let password: String
    }

    struct UserFavoriteSpots: Codable {
        let favoriteSpots: [Spot]
    }

    // Save user data
    func saveUser(user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }

    // Load user data
    func loadUser(completion: @escaping (User?) -> Void) {
        guard let jwt = keychain.get("userJWT") else {
            completion(nil)
            return
        }

        let url = URL(string: "\(baseURL)/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Changed to GET as it's typically used for retrieving data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                completion(nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)") // Print the status code
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let dateFormatter = ISO8601DateFormatter()
                            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            decoder.dateDecodingStrategy = .custom { decoder in
                                let container = try decoder.singleValueContainer()
                                let dateStr = try container.decode(String.self)

                                if let date = dateFormatter.date(from: dateStr) {
                                    return date
                                }
                                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateStr)")
                            }

                            let decodedResponse = try decoder.decode(MeServerResponse.self, from: data)
                            print("Server Response: \(decodedResponse)") // Print the decoded server response
                            if let user = decodedResponse.user {
                                completion(user)
                            } else {
                                completion(nil)
                            }
                        } catch {
                            print("Failed to decode response: \(error)")
                            completion(nil)
                        }

                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = ISO8601DateFormatter()
                    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)

                        if let date = dateFormatter.date(from: dateStr) {
                            return date
                        }
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateStr)")
                    }

                    let response = try decoder.decode(ServerResponse.self, from: data)
                    if response.status == "ok" {
                        self.keychain.set(response.token ?? "no token", forKey: "userJWT")
                        if let user = response.user {
                            self.saveUser(user: user)
                        }
                        completion(true, nil)
                    } else {
                        completion(false, response.message)
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false, "Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func register(user: PreAddUser, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let userWithPass = UserRegistration(user: user, password: password)
        let body = userWithPass
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                    if response.status == "ok" {
                        completion(true, nil)
                    } else {
                        completion(false, response.message)
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false, "Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "savedUser")
        keychain.delete("userJWT")
    }

    func searchUsers(query: String, completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/searchUsers")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let searchQuery = ["searchTerm": query]
        let jsonData = try? JSONSerialization.data(withJSONObject: searchQuery)

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }

            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let response = try decoder.decode(UserSearchServerResponse.self, from: data)
                if response.status == "ok" {
                    completion(response.users, nil)
                } else {
                    print("Error: \(response.message)")
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: response.message]))
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil, error)
            }
        }

        task.resume()
    }

    func addFavoriteSpot(spot: Spot, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/addFavoriteSpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["spotId": spot.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            // Check the response and decide the completion block
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }

    func getFavoriteSpots(completion: @escaping ([Spot]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getFavoriteSpots")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }

            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let spots = try decoder.decode(UserFavoriteSpots.self, from: data)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Successfully pulled favorite spots")
                    completion(spots.favoriteSpots, nil)
                } else {
                    print("Could not get favorite Spots")
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil, error)
            }
        }.resume()
    }

    func removeFavoriteSpot(spot: Spot, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/removeFavoriteSpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["spotId": spot.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request: \(error)")
                completion(false, "Error sending request: \(error.localizedDescription)")
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                print("No data returned or invalid response")
                completion(false, "No data returned or invalid response")
                return
            }

            // Print the response from the server
            if let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            }

            if httpResponse.statusCode == 200 {
                print("Spot successfully removed")
                completion(true, nil)
            } else {
                // Attempt to decode the error message if possible
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(UserFavoriteSpots.self, from: data)
                    completion(false, "Error Removing Favorite Spot")
                } catch {
                    print("Failed to decode error response: \(error)")
                    completion(false, "Failed to decode error response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func updateUserEmail(newEmail: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/updateEmail")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jwt = keychain.get("userJWT") ?? ""
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body = ["newEmail": newEmail]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(UpdateUserResponse.self, from: data)
                            self.keychain.set(response.token ?? "no token", forKey: "userJWT")
                            completion(true, nil)
                        } catch {
                            completion(false, "Failed to decode response: \(error.localizedDescription)")
                        }
                    } else {
                        completion(false, "No data received")
                    }
                } else {
                    completion(false, "HTTP Error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    func updateUserPassword(newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/updatePassword")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jwt = keychain.get("userJWT") ?? ""
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body = ["newPassword": newPassword]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(UpdateUserResponse.self, from: data)
                            self.keychain.set(response.token ?? "no token", forKey: "userJWT")
                            completion(true, nil)
                        } catch {
                            completion(false, "Failed to decode response: \(error.localizedDescription)")
                        }
                    } else {
                        completion(false, "No data received")
                    }
                } else {
                    completion(false, "HTTP Error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    func updateUserBio(newBio: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/updateBio")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jwt = keychain.get("userJWT") ?? ""
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body = ["newBio": newBio]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Server Response: \(error.localizedDescription)")
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("Server Response: HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(UpdateBioResponse.self, from: data)
                            print("Server Response1: \(response.message)")
                            completion(true, nil)
                        } catch {
                            print("Server Response2: \(error.localizedDescription)")
                            completion(false, "Failed to decode response: \(error.localizedDescription)")
                        }
                    } else {
                        print("Server Response: No data received")
                        completion(false, "No data received")
                    }
                } else {
                    print("Server Response: HTTP Error: \(httpResponse.statusCode)")
                    completion(false, "HTTP Error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    func updateUsername(newUsername: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/updateUsername")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jwt = keychain.get("userJWT") ?? ""
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body = ["newUsername": newUsername]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "HTTP Request Failed: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(UpdateUserResponse.self, from: data)
                            completion(true, nil)
                        } catch {
                            completion(false, "Failed to decode response: \(error.localizedDescription)")
                        }
                    } else {
                        completion(false, "No data received")
                    }
                } else if httpResponse.statusCode == 409 {
                    completion(false, "Username is already taken")
                } else {
                    completion(false, "HTTP Error: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
