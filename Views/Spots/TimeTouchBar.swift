//
//  TimeTouchBar.swift
//  Stoked
//
//  Created by Noah Hurley on 6/21/24.
//

import SwiftUI

struct TimeTouchBar: View {
    @Binding var selectedTime: Date
    let times = ["12 AM", "4 AM", "8 AM", "12 PM", "4 PM", "8 PM"] // Labels every 4 hours, excluding the final "12 AM"

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

                // Draw gray ticks every 4 hours above the line
                Path { path in
                    let width = geometry.size.width
                    let tickInterval = width / 6 // There are 6 intervals in 24 hours for every 4 hours
                    for i in 0 ..< 6 {
                        let xPosition = CGFloat(i) * tickInterval
                        path.move(to: CGPoint(x: xPosition, y: 10))
                        path.addLine(to: CGPoint(x: xPosition, y: 0)) // Adjusted to draw upwards
                    }
                }
                .stroke(Color.gray, lineWidth: 2)

                // Draw a green tick for the selected time
                Path { path in
                    let width = geometry.size.width
                    let totalHours = Calendar.current.component(.hour, from: selectedTime)
                    let position = CGFloat(totalHours) / 24 * width
                    path.move(to: CGPoint(x: position, y: 0))
                    path.addLine(to: CGPoint(x: position, y: -15)) // Adjusted to draw upwards
                }
                .stroke(Color.green, lineWidth: 3)

                HStack(spacing: 0) {
                    ForEach(times, id: \.self) { time in
                        Text(time)
                            .font(.caption)
                            .frame(width: geometry.size.width / 6, alignment: .leading)
                    }
                }
                .padding(.leading, -17)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateSelectedTime(from: value, in: geometry.size.width)
                    }
                    .onEnded { value in
                        updateSelectedTime(from: value, in: geometry.size.width)
                    }
            )
        }
        .frame(height: 40)
    }

    private func updateSelectedTime(from value: DragGesture.Value, in totalWidth: CGFloat) {
        let tapLocation = value.location.x
        let hours = Int((tapLocation / totalWidth) * 24)
        let calendar = Calendar.current
        selectedTime = calendar.date(bySettingHour: hours, minute: 0, second: 0, of: selectedTime) ?? selectedTime
    }
}

// #Preview {
//    TimeTouchBar()
// }
