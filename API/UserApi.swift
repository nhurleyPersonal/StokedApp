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
    func loadUser() -> User? {
        if let savedUser = UserDefaults.standard.object(forKey: "savedUser") as? Data {
            if let loadedUser = try? JSONDecoder().decode(User.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
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

    func addFavoriteSpot(user: User, spot: Spot, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/addFavoriteSpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["userId": user.id, "spotId": spot.id]
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

    func getFavoriteSpots(user: User, completion: @escaping ([Spot]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getFavoriteSpots")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(["userId": user.id])
            request.httpBody = jsonData
        } catch {
            print("Error encoding user: \(error)")
            completion(nil, error)
            return
        }

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
                }
                else {
                    print("Could not get favorite Spots")
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil, error)
            }
        }.resume()
    }

    func removeFavoriteSpot(user: User, spot: Spot, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(baseURL)/removeFavoriteSpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["userId": user.id, "spotId": spot.id]
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
}
