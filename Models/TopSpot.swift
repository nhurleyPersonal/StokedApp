import Foundation

struct TopSpot: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var Date: Date
    var sessions: [Session]
    var overallScore: Double
    var surfData: SurfData
    var descriptions: [String]
}
