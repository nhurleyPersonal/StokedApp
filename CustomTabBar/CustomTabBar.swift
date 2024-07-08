//
//  CustomTabBar.swift
//  Stoked
//
//  Created by Noah Hurley on 6/27/24.
//

import Foundation
import SwiftUI
import UIKit

struct CustomTabBar: UIViewControllerRepresentable {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var currentUser: CurrentUser

    func makeUIViewController(context _: Context) -> UITabBarController {
        let tabBarController = UITabBarController()

        // Set the overall appearance to dark
        tabBarController.overrideUserInterfaceStyle = .dark

        // Customize the appearance of the tab bar for dark mode
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.black
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.green

        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        // Home View Controller
        let homeVC = UIHostingController(rootView: HomeView(isLoggedIn: $isLoggedIn, currentUser: currentUser))
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)

        // Search View Controller
        let searchVC = UIHostingController(rootView: MainSearchView())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)

        // Session Submission Form
        let sessionVC = UIHostingController(rootView: SessionSubmissionForm())
        sessionVC.tabBarItem = UITabBarItem(title: "Log Session", image: UIImage(systemName: "plus.circle.fill"), selectedImage: nil)

        // Profile View Controller
        let profileVC = UIHostingController(rootView: ProfileView(currentUser: currentUser, isLoggedIn: $isLoggedIn))
        profileVC.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(systemName: "figure.surfing"), selectedImage: nil)

        tabBarController.viewControllers = [homeVC, searchVC, sessionVC, profileVC]

        return tabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context _: Context) {
        // Customize the "Log Session" tab item
        if let items = uiViewController.tabBar.items, items.count > 2 {
            let sessionItem = items[2]
            sessionItem.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
        }
    }
}
