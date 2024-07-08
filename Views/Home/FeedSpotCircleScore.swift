//
//  FeedSpotCircleScore.swift
//  Stoked
//
//  Created by Noah Hurley on 5/3/24.
//

import SwiftUI

struct FeedSpotCircleScore: View {
    var score: Double
    var sliceDegrees: Double {
        360.0 * (1.0 - (score / 10.0))
    }

    var scoreColor: Color {
        switch score {
        case 0 ..< 3:
            return .red
        case 3 ..< 5:
            return .orange
        case 5 ..< 7:
            return .yellow
        case 7 ..< 9:
            return .green
        case 9 ..< 10:
            return Color.green.opacity(0.7)
        default:
            return .purple
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(1.0 - sliceDegrees / 360.0)) // Cut out a slice
                .stroke(scoreColor, lineWidth: 2)
                .rotationEffect(.degrees(-90 + sliceDegrees)) // Rotate to start from top
                .frame(width: 70, height: 70)
            Text(score.isNaN ? "--" : String(format: "%.1f", score))
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    TopSpotCircleScore(score: 10)
}
