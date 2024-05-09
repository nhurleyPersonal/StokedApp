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

    let sessions: [Session]
    let topSpots: [TopSpot]

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("STOKED")
                            .font(.largeTitle)
                            .padding(.top)
                            .foregroundColor(.white)
                            .kerning(5)

                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 20)

                    Spacer()

                    ZStack {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
                            .edgesIgnoringSafeArea(.all)

                        GeometryReader { geometry in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(0 ..< 3) { index in
                                        TopSpotsView(topSpot: topSpots.randomElement()!)
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
                        }

                        Text("Top Spots Today")
                            .foregroundColor(.white)
                            .padding(.horizontal, 3)
                            .background(Color(hex: "212121"))
                            .offset(x: -UIScreen.main.bounds.width * 0.325, y: -UIScreen.main.bounds.height * 0.325)
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

                    ForEach(sessions.prefix(3).indices, id: \.self) { index in
                        SessionView(session: sessions[index])
                    }
                }
                .padding()
            }
            .navigationBarTitle("STOKED", displayMode: .inline)
        }
    }
}

#Preview {
    HomeView(sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
}
