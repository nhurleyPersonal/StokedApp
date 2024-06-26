import Foundation
import KeychainSwift

class SessionAPI {
    static let shared = SessionAPI()

    private let baseURL = "https://stoked-backend-a7f20ecf2b79.herokuapp.com/api"
    var currentUser: CurrentUser?

    struct ServerResponse: Codable {
        let status: String
        let message: String
        let token: String?
        let sessions: [Session]?
    }

    struct SpotServerResponse: Codable {
        let status: String
        let message: String
        let token: String?
        let spots: [Spot]?
    }

    func addSession(session: PreAddSession) {
        let url = URL(string: "\(baseURL)/addSession")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(session)
            request.httpBody = jsonData
        } catch {
            print("Error encoding session: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error sending request: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let response = try JSONDecoder().decode(ServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Session added successfully")
                    DispatchQueue.main.async {
                        self.currentUser?.shouldRefresh = true
                    }
                } else {
                    print("Error: \(response.message)")
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }

        task.resume()
    }

    func getRandomBoard(completion: @escaping (Board?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getRandomBoard")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

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
                let board = try JSONDecoder().decode(Board.self, from: data)
                completion(board, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }

    func getRandomSpot(completion: @escaping (Spot?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getRandomSpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

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
                let spot = try JSONDecoder().decode(Spot.self, from: data)
                completion(spot, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }

    func getSessionsByUser(user: User, completion: @escaping ([Session]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getSessionsByUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user: \(error)")
            completion(nil, error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error sending request: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }

            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                let response = try decoder.decode(ServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Sessions retrieved successfully")

                    completion(response.sessions, nil)
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

    func getAllSpots(completion: @escaping ([Spot]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getAllSpots")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

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
                let response = try JSONDecoder().decode(SpotServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Spots fetched successfully")
                    completion(response.spots, nil)
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

    func getSessionsBySpot(spot: Spot, completion: @escaping ([Session]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getSessionsBySpot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(spot)
            request.httpBody = jsonData
        } catch {
            print("Error encoding spot: \(error)")
            completion(nil, error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error sending request: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }

            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                let response = try decoder.decode(ServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Sessions retrieved successfully")
                    completion(response.sessions, nil)
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
}
