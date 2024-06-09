import Foundation

class CurrentUser: ObservableObject {
    @Published var user: User?
    @Published var shouldRefresh = true
    @Published var shouldRefreshHome = true
}
