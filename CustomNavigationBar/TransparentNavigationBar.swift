//
//  TransparentNavigationBar.swift
//  Stoked
//
//  Created by Noah Hurley on 6/26/24.
//

import Foundation
import SwiftUI

struct TransparentNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Set background color to black with 50% opacity
                appearance.shadowColor = .clear // Remove the shadow

                // Apply the appearance to the navigation bar
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            .onDisappear {
                // Reset to default when view disappears if needed
                UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
                UINavigationBar.appearance().compactAppearance = UINavigationBarAppearance()
                UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
            }
    }
}

// Extension to easily add this modifier to any view
extension View {
    func transparentNavigationBar() -> some View {
        modifier(TransparentNavigationBar())
    }
}
