//
//  StokedApp.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import KeychainSwift
import SwiftUI

@main
struct StokedApp: App {
    @StateObject private var currentUser = CurrentUser()
    let keychain = KeychainSwift()
    @State private var isLoggedIn = false

    // Initialize the appearance of the navigation bar
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 0.5)
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
                .environmentObject(currentUser)
                .onAppear {
                    if let jwt = keychain.get("userJWT"), let user = UserAPI.shared.loadUser() {
                        isLoggedIn = true
                        currentUser.user = user
                        print(currentUser.user, user)
                    }
                }
        }
    }
}
