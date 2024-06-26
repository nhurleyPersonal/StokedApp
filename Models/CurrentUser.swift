import Foundation

class CurrentUser: ObservableObject {
    @Published var user: User?
    @Published var favoriteSpots: [Spot] = []
    @Published var shouldRefresh = true
    @Published var shouldRefreshHome = true
}
