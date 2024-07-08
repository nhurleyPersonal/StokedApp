//
//  SetSessionScoreView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/8/24.
//

import SwiftUI

struct SetSessionScoreView: View {
    @Binding var sessionScore: Double
    let scoreRange: ClosedRange<Double> = 0 ... 10
    let step: Double = 0.1
    let tickMarks: [Double] = [0, 2, 4, 6, 8, 10] // Specific points where ticks should be displayed

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Draw the main horizontal line
                Path { path in
                    let width = geometry.size.width
                    path.move(to: CGPoint(x: 0, y: 20))
                    path.addLine(to: CGPoint(x: width, y: 20))
                }
                .stroke(Color.white, lineWidth: 2)

                // Draw ticks at specified points
                Path { path in
                    let width = geometry.size.width
                    for tick in tickMarks {
                        let xPosition = CGFloat(tick / scoreRange.upperBound) * width
                        path.move(to: CGPoint(x: xPosition, y: 10))
                        path.addLine(to: CGPoint(x: xPosition, y: 0)) // Adjusted to draw upwards
                    }
                }
                .stroke(Color.gray, lineWidth: 2)

                // Draw a green tick for the selected score
                Path { path in
                    let width = geometry.size.width
                    let position = (sessionScore - scoreRange.lowerBound) / (scoreRange.upperBound - scoreRange.lowerBound) * width
                    path.move(to: CGPoint(x: position, y: 0))
                    path.addLine(to: CGPoint(x: position, y: -15)) // Adjusted to draw upwards
                }
                .stroke(Color.green, lineWidth: 3)

                // Labels for min and max values
                HStack {
                    Text("\(scoreRange.lowerBound, specifier: "%.1f")")
                        .font(.caption)
                        .frame(width: geometry.size.width / 2, alignment: .leading)
                    Text("\(scoreRange.upperBound, specifier: "%.1f")")
                        .font(.caption)
                        .frame(width: geometry.size.width / 2, alignment: .trailing)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateSelectedScore(from: value, in: geometry.size.width)
                    }
                    .onEnded { value in
                        updateSelectedScore(from: value, in: geometry.size.width)
                    }
            )
        }
        .frame(width: 300, height: 40) // Set the frame to screen width
        .padding(.horizontal, 20)
    }

    private func updateSelectedScore(from value: DragGesture.Value, in totalWidth: CGFloat) {
        let tapLocation = value.location.x
        let newScore = (tapLocation / totalWidth) * (scoreRange.upperBound - scoreRange.lowerBound) + scoreRange.lowerBound
        // Clamp the score to the range to prevent it from going below 0 or above 10
        sessionScore = min(max(round(newScore / step) * step, scoreRange.lowerBound), scoreRange.upperBound)
    }
}

// #Preview {
//    SetSessionScoreView(sessionScore: <#T##Binding<Double>#>)
// }
