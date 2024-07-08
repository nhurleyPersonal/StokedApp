//
//  FeedApi.swift
//  Stoked
//
//  Created by Noah Hurley on 6/27/24.
//

import Foundation
import KeychainSwift

struct FeedServerResponse: Codable {
    let page: Int
    let sessions: [Session]
}

class FeedAPI {
    static let shared = FeedAPI()
    private let baseURL = "https://stoked-backend-a7f20ecf2b79.herokuapp.com/api"

    func getFavoriteSpotsFeed(page: Int, limit: Int = 10, completion: @escaping ([Session]?, Int?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getFavoriteSpotsFeed")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["page": page, "limit": limit]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }

            guard let data = data else {
                completion(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }

            if httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let response = try decoder.decode(FeedServerResponse.self, from: data)
                    print("Feed loaded successfully")
                    completion(response.sessions, response.page, nil)
                } catch {
                    print("Error decoding response: \(error)")
                    completion(nil, nil, error)
                }
            } else {
                completion(nil, nil, NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve feed with status code: \(httpResponse.statusCode)"]))
            }
        }.resume()
    }
}
