//
//  DescriptionListView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/3/24.
//

import SwiftUI

struct DescriptionListView: View {
    var description: [String]
    var score: Double
    var dividerHeight: Double {
        for item in description {
            if item.count >= 8 {
                return 40.0
            }
        }
        return 20.0
    }

    func getDividerColor(score: Double, index: Int) -> Color {
        let redDividerColors = [
            Color(red: 0.5, green: 0, blue: 0), // Dark red
            Color(red: 0.7, green: 0, blue: 0), // Medium-dark red
            Color(red: 0.9, green: 0, blue: 0), // Medium-bright red
            Color(red: 1.0, green: 0, blue: 0), // Bright red
        ]

        let orangeDividerColors = [
            Color(red: 0.5, green: 0.25, blue: 0), // Dark orange
            Color(red: 0.7, green: 0.35, blue: 0), // Medium-dark orange
            Color(red: 0.9, green: 0.45, blue: 0), // Medium-bright orange
            Color(red: 1.0, green: 0.5, blue: 0), // Bright orange
        ]

        let yellowDividerColors = [
            Color(red: 0.5, green: 0.5, blue: 0), // Dark yellow
            Color(red: 0.7, green: 0.7, blue: 0), // Medium-dark yellow
            Color(red: 0.9, green: 0.9, blue: 0), // Medium-bright yellow
            Color(red: 1.0, green: 1.0, blue: 0), // Bright yellow
        ]

        let greenDividerColors = [
            Color(red: 0, green: 0.5, blue: 0), // Dark green
            Color(red: 0, green: 0.7, blue: 0), // Medium-dark green
            Color(red: 0, green: 0.9, blue: 0), // Medium-bright green
            Color(red: 0, green: 1.0, blue: 0), // Bright green
        ]

        let purpleDividerColors = [
            Color(red: 0.5, green: 0, blue: 0.5), // Dark purple
            Color(red: 0.7, green: 0, blue: 0.7), // Medium-dark purple
            Color(red: 0.9, green: 0, blue: 0.9), // Medium-bright purple
            Color(red: 1.0, green: 0, blue: 1.0), // Bright purple
        ]

        if score <= 3 {
            return redDividerColors[index]
        } else if score <= 5 {
            return orangeDividerColors[index]
        } else if score <= 7 {
            return yellowDividerColors[index]
        } else if score <= 9 {
            return greenDividerColors[index]
        } else {
            return purpleDividerColors[index]
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            ForEach(0 ..< min(description.count, 5)) { index in
                Text(description[index])
                    .foregroundColor(.white)
                if index != min(description.count, 5) - 1 {
                    Divider()
                        .frame(width: 2, height: dividerHeight)
                        .background(getDividerColor(score: score, index: index))
                }
            }
        }
    }
}

//#Preview {
//    DescriptionListView(description: DummyData.generateDummyTopSpot().descriptions, score: 8.8)
//}
