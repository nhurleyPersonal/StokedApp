import Foundation
import KeychainSwift

class SpotAPI {
    static let shared = SpotAPI()

    private let baseURL = "https://stoked-backend-a7f20ecf2b79.herokuapp.com/api"
    var currentUser: CurrentUser?

    struct SpotServerResponse: Codable {
        let status: String
        let message: String
        let token: String?
        let spots: [Spot]?
    }

    func searchSpots(query: String, completion: @escaping ([Spot]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/searchSpots")!
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
}
