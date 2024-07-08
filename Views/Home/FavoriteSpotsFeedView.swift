//
//  FavoriteSpotsFeedView.swift
//  Stoked
//
//  Created by Noah Hurley on 6/27/24.
//

import SwiftUI

struct SessionGroupKey: Hashable {
    let spotId: String
}

struct FavoriteSpotsFeedView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var sessions: [Session] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    private let limit = 10

    var body: some View {
        ScrollView {
            LazyVStack {
                // Group sessions by spot using the custom struct
                let groupedSessions = Dictionary(grouping: sessions) { session -> SessionGroupKey in
                    SessionGroupKey(spotId: session.spot.id)
                }

                // Iterate through each spot and create a FeedSpotView
                ForEach(currentUser.favoriteSpots, id: \.id) { spot in
                    if let sessionsForSpot = groupedSessions[SessionGroupKey(spotId: spot.id)] {
                        FeedSpotView(sessions: sessionsForSpot, spot: spot)
                    } else {
                        FeedSpotView(sessions: [], spot: spot)
                    }
                }

                if isLoading {
                    ProgressView()
                }
            }
        }
        .refreshable {
            loadFavoriteSpotsFeed()
        }
        .onAppear {
            if sessions.isEmpty {
                loadFavoriteSpotsFeed()
            }
        }
    }

    private func loadFavoriteSpotsFeed() {
        guard !isLoading else { return }
        guard let userId = currentUser.user?.id else { return }
        isLoading = true
        FeedAPI.shared.getFavoriteSpotsFeed(page: currentPage, limit: limit) { sessions, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let sessions = sessions {
                    self.sessions.append(contentsOf: sessions)
                    if !sessions.isEmpty {
                        self.currentPage += 1
                    }
                } else if let error = error {
                    print("Error loading favorite spots feed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func loadMoreSpots() {
        loadFavoriteSpotsFeed()
    }
}
