import Foundation

struct TideData: Hashable, Codable, Identifiable {
    var id: String
    var date: String
    var stationId: String
    var lastUpdated: String
    var tideData: [TideEntry]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date, stationId, lastUpdated, tideData
    }
}

struct TideEntry: Hashable, Codable {
    var time: String
    var value: String
}
