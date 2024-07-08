//
//  SearchBarButtonView.swift
//  Stoked
//
//  Created by Noah Hurley on 6/27/24.
//

import SwiftUI

struct SearchBarButtonView: View {
    var body: some View {
        Button(action: {
            // Action to present MainSearchView
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search Users and Spots...")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(8)
            .background(Color(.systemGray6)) // Use system background color for light/dark mode compatibility
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchBarButtonView()
}
