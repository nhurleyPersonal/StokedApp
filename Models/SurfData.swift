import Foundation

struct SurfData: Hashable, Codable, Identifiable {
    var id: String
    var spot: Spot
    var date: Date
    var swellHeight: Double
    var swellPeriod: Double
    var swellDirection: Int
    var windSpeed: Double
    var windDirection: Int
    var tide: String
}
