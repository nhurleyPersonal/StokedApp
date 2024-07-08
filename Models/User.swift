import Foundation

struct User: Hashable, Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var favoriteSpots: [String]
    var createdAt: Date
    var recentSpots: [String]

    var tagline: String?
    var skillLevel: String?
    var homeSpot: Spot?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, username, favoriteSpots, createdAt, recentSpots, tagline, skillLevel, homeSpot
    }
}

struct PreAddUser: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let favoriteSpots: [String]
    let createdAt: Date
    let recentSpots: [String]

    let tagline: String?
    let skillLevel: String?
    let homeSpot: Spot?
}
