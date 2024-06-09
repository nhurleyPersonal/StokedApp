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

            ScrollView {
                VStack(alignment: .leading) {
                    ZStack {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
                            .edgesIgnoringSafeArea(.all)
                            .zIndex(1)

                        GeometryReader { geometry in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(0 ..< 3) { index in
                                        TopSpotsView(topSpot: self.dummyTopSpot, topSpotSessions: self.topSpotSessions)
                                            .frame(width: geometry.size.width)
                                            .tag(index)
                                    }
                                }
                            }
                            .content.offset(x: -CGFloat(self.currentPage) * geometry.size.width)
                            .frame(width: geometry.size.width, alignment: .leading)
                            .gesture(
                                DragGesture().onEnded { value in
                                    if value.predictedEndTranslation.width > geometry.size.width / 2, self.currentPage > 0 {
                                        withAnimation {
                                            self.currentPage -= 1
                                        }
                                    } else if value.predictedEndTranslation.width < -geometry.size.width / 2, self.currentPage < 2 {
                                        withAnimation {
                                            self.currentPage += 1
                                        }
                                    }
                                }
                            )
                            .mask(
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
                            )
                        }
                        .zIndex(0)

                        Text("Top Spots Today")
                            .foregroundColor(.white)
                            .padding(.horizontal, 3)
                            .background(Color(hex: "212121"))
                            .offset(x: -UIScreen.main.bounds.width * 0.325, y: -UIScreen.main.bounds.height * 0.325)
                            .zIndex(1)
                    }

                    HStack {
                        ForEach(0 ..< 3) { index in
                            Circle()
                                .fill(index == currentPage ? Color.blue : Color.gray)
                                .frame(width: 10, height: 10)
                                .padding(2)
                        }
                    }

                    Divider()

                    Text("Buddies' sessions")
                        .font(.title2)
                        .padding(.vertical)

                    // ForEach(sessions.prefix(3).indices, id: \.self) { index in
                    //     SessionView(session: sessions[index])
                    // }
                }
                .padding()
            }
            .navigationBarTitle("STOKED", displayMode: .inline)
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

// #Preview {
//    @State var isLoggedIn = true
//
//    HomeView(isLoggedIn: $isLoggedIn, sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
// }
