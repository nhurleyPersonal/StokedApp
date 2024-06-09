import Combine
import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet {
            runSearch(query: searchText)
            if searchText.isEmpty {
                spots = []
                users = []
            }
        }
    }

    @Published var spots: [Spot] = []
    @Published var users: [User] = []
    private var searchCancellable: Cancellable? = nil
    private var searchCache: [String: (spots: [Spot], users: [User])] = [:]

    init() {
        searchCancellable = $searchText
            .debounce(for: .seconds(0.25), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] in self?.runSearch(query: $0) }
    }

    func runSearch(query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }

        if let cachedResults = searchCache[query] {
            spots = cachedResults.spots
            users = cachedResults.users
        } else {
            SpotAPI.shared.searchSpots(query: query) { [weak self] spots, error in
                if let error = error {
                    print("Error searching for spots: \(error)")
                } else if let spots = spots {
                    DispatchQueue.main.async {
                        self?.spots = spots
                        self?.searchCache[query]?.spots = spots
                    }
                }
            }
            UserAPI.shared.searchUsers(query: query) { [weak self] users, error in
                if let error = error {
                    print("Error searching for users: \(error)")
                } else if let users = users {
                    DispatchQueue.main.async {
                        self?.users = users
                        self?.searchCache[query]?.users = users
                    }
                }
            }
            // Cache the results after fetching
            searchCache[query] = (spots: spots, users: users)
        }
    }

    private func pruneResults() {
        if !searchText.isEmpty {
            spots = spots.filter { $0.name.contains(searchText) }
            users = users.filter { $0.username.contains(searchText) }
        }
    }
}

struct MainSearchView: View {
    @ObservedObject private var viewModel = SearchViewModel()

    func userSort(user1: User, user2: User, searchTerm: String) -> Bool {
        let fields1 = [user1.username, user1.lastName, user1.firstName]
        let fields2 = [user2.username, user2.lastName, user2.firstName]

        for (field1, field2) in zip(fields1, fields2) {
            let range1 = field1.range(of: searchTerm)
            let range2 = field2.range(of: searchTerm)

            if let range1 = range1, let range2 = range2 {
                return range1.lowerBound < range2.lowerBound
            } else if range1 != nil {
                return true
            } else if range2 != nil {
                return false
            }
        }

        return false
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "212121")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 27, height: 27)
                            .foregroundColor(.green)
                            .padding(.leading, 10)
                        TextField("Search Users and Spots...", text: $viewModel.searchText)
                            .keyboardType(.webSearch)
                            .disableAutocorrection(true)
                            .padding(10)
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.white),
                                alignment: .bottom
                            )
                    }
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)

                    SearchResultsView(spots: viewModel.spots,
                                      users: viewModel.users.sorted(by: { userSort(user1: $0, user2: $1, searchTerm: viewModel.searchText) }))

                    Spacer()
                }
                .padding(.top, 20)
            }
        }
    }
}
