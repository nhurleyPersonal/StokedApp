//
//  HomeView.swift
//  Stoked
//
//  Created by Noah Hurley on 4/24/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.theme) var theme
    @State private var isPressed = false
    @State private var currentPage = 0
    @State private var isMainSearchViewPresented = false
    @Binding var isLoggedIn: Bool
    var currentUser: CurrentUser
    @State private var topSpotSessions: [Session] = []
    @State private var selectedTab: Int = 0 // New state for managing selected tab

    static let dummySwellComponent = SwellComponent(period: 13.97, direction: 208.63, wave_height: 1.7056)

    static let dummySurfData = SurfData(
        id: "66624d2f8c038d8bda02d381",
        spotId: "1",
        name: "665f8dc096a998713f890e97",
        date: 123_456_789,
        primarySwellCompassDirection: "SSW",
        primarySwellDirection: 208.59,
        primarySwellHeight: 1.9351999999999998,
        primarySwellPeriod: 13.97,
        swellComponents: [dummySwellComponent, dummySwellComponent],
        windCompassDirection: "SW",
        windDirection: 222.11,
        windSpeed: 6.822850000000001
    )

    let dummyTopSpot = TopSpot(
        id: "1",
        name: "Dummy Spot",
        Date: Date(),
        sessions: [], // You can replace this with an array of dummy Session objects
        overallScore: 5.0,
        surfData: dummySurfData, // You can replace this with a dummy SurfData object
        descriptions: ["Wavy", "Big", "Clean", "Crowded", "Fun"]
    )

    private func fetchSessions() {
        if currentUser.user != nil {
            SessionAPI().getSessionsByUser(user: currentUser.user!) { sessions, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error getting sessions: \(error)")
                    } else if let sessions = sessions {
                        self.topSpotSessions = sessions
                    }
                    self.currentUser.shouldRefreshHome = false
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Header section
                VStack {
                    HStack {
                        Image("BannerLogo")
                            .padding(.leading, 30)

                        Spacer()

                        NavigationLink(destination: MainSearchView(showEscape: true).navigationBarHidden(true), isActive: $isMainSearchViewPresented) {
                            Button(action: {
                                isMainSearchViewPresented = true
                            }) {
                                Image(systemName: "magnifyingglass.circle")
                                    .resizable()
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 15)
                    }
                    .padding(.top, 15)

                    Divider()
                        .frame(height: 1)
                        .padding(.vertical, 5)

                    HStack(spacing: 20) {
                        Button(action: {
                            selectedTab = 0
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Spots")
                                    .font(.system(size: 12))
                            }
                        }
                        .buttonStyle(TabButtonStyle(isSelected: selectedTab == 0))

                        Button(action: {
                            selectedTab = 1
                        }) {
                            HStack {
                                Text("Buddies")
                                    .font(.system(size: 12))
                            }
                        }
                        .buttonStyle(TabButtonStyle(isSelected: selectedTab == 1))

                        Button {
                            selectedTab = 2
                        } label: {
                            Image(systemName: "waveform")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(TabButtonStyle(isSelected: selectedTab == 2))
                        Spacer()
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                    .padding(.top, -10)
                    .padding(.bottom, 10)
                }
                .background(Color(hex: "212121")) // Ensure the header has a background that matches the ZStack

                // Content section
                ScrollView {
                    Group {
                        if selectedTab == 0 {
                            FavoriteSpotsFeedView() // Temporary view for selectedTab = 0
                        } else if selectedTab == 1 {
                            Spacer() // Temporary view for selectedTab = 1
                        } else if selectedTab == 2 {
                            TopSpotsContainerView(currentPage: $currentPage, topSpotSessions: topSpotSessions, dummyTopSpot: dummyTopSpot)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // This ensures the content area fills the available space
                }
            }
        }
        .onReceive(currentUser.$shouldRefreshHome) { _ in
            if currentUser.shouldRefreshHome {
                fetchSessions()
            }
        }
        .refreshable {
            currentUser.shouldRefreshHome = true
            fetchSessions()
        }
    }
}

struct TabButtonStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .frame(minWidth: 50)
            .background(isSelected ? Color.white : Color.clear)
            .foregroundColor(isSelected ? .black : .white) // Apply foreground color to the entire button content
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 1) // Adds a white border
            )
    }
}

// #Preview {
//    @State var isLoggedIn = true
//
//    HomeView(isLoggedIn: $isLoggedIn, sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
// }
