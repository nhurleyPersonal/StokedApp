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
    @State private var selection = 0
    @State private var resetNavigationID = UUID()
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                // Show a loading indicator or title screen while loading
                VStack {
                    TitlePageView()
                }
            } else if isLoggedIn {
                let selectable = Binding(
                    get: { self.selection },
                    set: { newValue in
                        if self.selection == newValue {
                            self.resetNavigationID = UUID()
                        }
                        self.selection = newValue
                    }
                )

                TabView(selection: selectable) {
                    NavigationView {
                        HomeView(isLoggedIn: $isLoggedIn, currentUser: currentUser)
                    }
                    .id(self.resetNavigationID)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                    MainSearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(1)

                    SessionSubmissionForm()
                        .tabItem {
                            Label("Log Session", systemImage: "plus.circle.fill")
                        }
                        .tag(2)

                    NavigationView {
                        ProfileView(currentUser: currentUser, isLoggedIn: $isLoggedIn)
                    }
                    .id(self.resetNavigationID)
                    .tabItem {
                        Label("My Profile", systemImage: "figure.surfing")
                    }
                    .tag(3)
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
                .colorScheme(.dark)
                .environment(\.theme, ThemeKey.defaultValue)
            } else {
                LoginView(onLogin: {
                    self.isLoggedIn = true
                    self.currentUser.shouldRefresh = true
                }, isLoggedIn: isLoggedIn)
            }
        }
        .onAppear {
            UserAPI.shared.loadUser { user in
                DispatchQueue.main.async {
                    if let user = user {
                        self.currentUser.user = user
                        self.isLoggedIn = true
                        // Fetch favorite spots after loading the user
                        UserAPI.shared.getFavoriteSpots { spots, error in
                            DispatchQueue.main.async {
                                if let spots = spots {
                                    self.currentUser.favoriteSpots = spots
                                } else if let error = error {
                                    print("Error loading favorite spots: \(error.localizedDescription)")
                                }
                                self.isLoading = false
                            }
                        }
                    } else {
                        self.isLoggedIn = false
                        self.isLoading = false
                    }
                }
            }
        }
        .environmentObject(currentUser) // Ensure currentUser is set as an environment object
    }
}

// #Preview {
//    ContentView().environment(isLoggedIn: true, \.theme, ThemeKey.defaultValue)
// }
