//
//  SetSessionScoreView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/8/24.
//

import SwiftUI

struct SetSessionScoreView: View {
    @State private var score: Double = 5
    @State private var dragOffset: CGFloat = 0
    @Binding var sessionScore: Double

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
                .frame(width: 100, height: 100)

            VStack {
                Image(systemName: "arrow.up")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                Text(String(format: "%.1f", score))
                    .font(.title)
                    .foregroundColor(.white)
                Image(systemName: "arrow.down")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
        }
        .frame(width: 100, height: 100)
        .background(Color.clear)
        .highPriorityGesture(
            DragGesture()
                .onChanged { gesture in
                    let dragAmount = -gesture.translation.height / 200 // Adjust this value to change the sensitivity of the drag
                    let newScore = score + Double(dragAmount)
                    score = min(max(newScore, 0), 10) // Clamp the score between 0 and 10
                    sessionScore = score
                }
        )
    }
}

// #Preview {
//    SetSessionScoreView(sessionScore: <#T##Binding<Double>#>)
// }
