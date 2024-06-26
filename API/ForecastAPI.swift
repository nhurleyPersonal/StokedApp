//
//  ForecastAPI.swift
//  Stoked
//
//  Created by Noah Hurley on 6/18/24.
//

import Foundation
import KeychainSwift

class ForecastAPI {
    static let shared = ForecastAPI()

    private let baseURL = "https://stoked-backend-a7f20ecf2b79.herokuapp.com/api"

    struct ForecastServerResponse: Codable {
        let status: String
        let message: String
        let surfData: [SurfData]?
    }

    struct TideDataServerResponse: Codable {
        let status: String
        let message: String
        let tideData: [TideData]?
    }

    func getForecastsRange(spotId: String, startDate: Date, endDate: Date, completion: @escaping ([SurfData]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/getForecastRange")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let body = [
            "_id": spotId,
            "startDate": round(startDate.timeIntervalSince1970),
            "endDate": round(endDate.timeIntervalSince1970),
        ] as [String: Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            print("Error encoding request body: \(error)")
            completion(nil, error)
            return
        }

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
                let response = try JSONDecoder().decode(ForecastServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Forecasts retrieved successfully")
                    completion(response.surfData, nil)
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

    func searchTides(tideStation: String, date: Date, completion: @escaping ([TideData]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/searchTidesByDay")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let jwt = keychain.get("userJWT") ?? ""
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let body = [
            "tideStation": tideStation,
            "date": date.timeIntervalSince1970,
        ] as [String: Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            print("Error encoding request body: \(error)")
            completion(nil, error)
            return
        }

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
                let response = try JSONDecoder().decode(TideDataServerResponse.self, from: data)
                if response.status == "ok" {
                    print("Tides retrieved successfully")
                    completion(response.tideData, nil)
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
