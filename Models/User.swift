import Foundation

struct User: Hashable, Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let tagline: String?
}
