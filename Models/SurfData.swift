import Foundation

struct SurfData: Hashable, Codable, Identifiable {
    var id: String
    var spotId: String
    var name: String
    var date: Double
    var primarySwellCompassDirection: String
    var primarySwellDirection: Double
    var primarySwellHeight: Double
    var primarySwellPeriod: Double
    var swellComponents: [SwellComponent]
    var windCompassDirection: String
    var windDirection: Double
    var windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case spotId, name, date, primarySwellCompassDirection, primarySwellDirection,
             primarySwellHeight, primarySwellPeriod, swellComponents,
             windCompassDirection, windDirection, windSpeed
    }
}

struct SwellComponent: Hashable, Codable {
    var period: Double
    var direction: Double
    var wave_height: Double
}
