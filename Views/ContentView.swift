//
//  ContentView.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ZStack {
            Color(hex: "902121") // <- or any other Color/Gradient/View you want
                .edgesIgnoringSafeArea(.all)

            TabView {
                
                HomeView(sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
                    .tabItem {
                        Label(
                            title: { Text("Home") },
                            icon: { Image(systemName: "house") }
                        )
                    }
                
                Text("Search")
                    .tabItem {
                        Label(
                            title: { Text("Search") },
                            icon: {
                                Image(systemName: "magnifyingglass")
                            }
                        )
                    }

                SessionSubmissionForm()
                    .tabItem {
                        Label(
                            title: { Text("Add Session") },
                            icon: {
                                Image(systemName: "figure.surfing")
                            }
                        )
                    }

                ZStack {
                    Color(.green)
                        .edgesIgnoringSafeArea(.top)
                    Text("User")
                }
                .tabItem {
                    Image(systemName: "face.dashed")
                    Text("User")
                }
            }

            .onAppear {
                let tabBarAppearance = UITabBarAppearance()

                // Set the background color
                tabBarAppearance.backgroundColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 0.1)

                // Set the color of the unselected items
                tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
                tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

                // Set the color of the selected items
                tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
                tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

                // Apply the appearance
                UITabBar.appearance().standardAppearance = tabBarAppearance
            }
        }
        .colorScheme(.dark)
        .environment(\.theme, ThemeKey.defaultValue)
    }
}

#Preview {
    ContentView().environment(\.theme, ThemeKey.defaultValue)
}
