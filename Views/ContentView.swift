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
            theme.darkDark // <- or any other Color/Gradient/View you want
                .edgesIgnoringSafeArea(.all)

            TabView {
                HomeView(sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
            }
        }
        .environment(\.theme, ThemeKey.defaultValue)
    }
}

#Preview {
    ContentView().environment(\.theme, ThemeKey.defaultValue)
}
