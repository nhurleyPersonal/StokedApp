//
//  ContentView.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import KeychainSwift
import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var currentUser: CurrentUser

    var body: some View {
        Group {
            if isLoggedIn {
                ZStack {
                    TabView {
                        NavigationView {
                            HomeView(isLoggedIn: $isLoggedIn,
                                     currentUser: currentUser)
                        }
                        .tabItem {
                            Label(
                                title: { Text("Home") },
                                icon: { Image(systemName: "house") }
                            )
                        }

                        MainSearchView()
                            .tabItem {
                                Label(
                                    title: { Text("Search") },
                                    icon: {
                                        Image(systemName: "magnifyingglass")
                                    }
                                )
                            }

                        NavigationView {
                            ProfileView(currentUser: currentUser, isLoggedIn: $isLoggedIn)
                        }
                        .tabItem {
                            Label(
                                title: { Text("My Profile") },
                                icon: {
                                    Image(systemName: "figure.surfing")
                                }
                            )
                        }
                    }

                    .onAppear {
                        let tabBarAppearance = UITabBarAppearance()

                        // Set the background color
                        tabBarAppearance.backgroundColor = UIColor(red: 50 / 255,
                                                                   green: 50 / 255, blue: 50 / 255, alpha: 0.1)

                        // Set the color of the unselected items
                        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
                        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes =
                            [.foregroundColor: UIColor.white]

                        // Set the color of the selected items
                        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
                        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes =
                            [.foregroundColor: UIColor.white]

                        // Apply the appearance
                        UITabBar.appearance().standardAppearance = tabBarAppearance
                    }
                }
                .colorScheme(.dark)
                .environment(\.theme, ThemeKey.defaultValue)
            } else {
                LoginOrRegisterView(onLogin: {
                    self.isLoggedIn = true
                    self.currentUser.shouldRefresh = true
                    print("Logged in!", self.isLoggedIn)
                }, isLoggedIn: isLoggedIn)
            }
        }
    }
}

// #Preview {
//    ContentView().environment(isLoggedIn: true, \.theme, ThemeKey.defaultValue)
// }
