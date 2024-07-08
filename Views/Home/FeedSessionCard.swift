//
//  FeedSessionCard.swift
//  Stoked
//
//  Created by Noah Hurley on 5/5/24.
//

import SwiftUI

struct FeedSessionCard: View {
    let session: Session

    var scoreColor: Color {
        switch session.overallScore {
        case 0 ..< 4:
            return Color(hex: "4B3630")
        case 4 ..< 6:
            return Color(hex: "6B4421")
        case 6 ..< 8:
            return Color(hex: "494B30")
        case 8 ..< 10:
            return Color(hex: "304B33")
        default:
            return Color(hex: "3D304B")
        }
    }

    private func formatDateRelative(to date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let dateFormatter = DateFormatter()

        // Set AM/PM symbols to lowercase
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        // Check if the date is today
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "'Today @ ' h:mm a"
            return dateFormatter.string(from: date)
        }

        // Check if the date is yesterday
        if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "'Yesterday @ ' h:mm a"
            return dateFormatter.string(from: date)
        }

        // Calculate the number of days ago
        let daysAgo = calendar.dateComponents([.day], from: date, to: now).day!
        if daysAgo <= 5 {
            dateFormatter.dateFormat = "EEEE '@ ' h:mm a" // Day of the week with time
            return dateFormatter.string(from: date)
        }

        // Format the date as 'Month day' or 'Month day, year' if more than a year old
        let yearsAgo = calendar.dateComponents([.year], from: date, to: now).year!
        if yearsAgo >= 1 {
            dateFormatter.dateFormat = "MMMM d, yyyy '@ ' h:mm a"
        } else {
            dateFormatter.dateFormat = "MMMM d '@ ' h:mm a"
        }

        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack {
            HStack {
                Text("@\(session.user.username) logged:")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .foregroundColor(.gray)

                Spacer()
                Text("\(formatDateRelative(to: session.sessionDatetime))")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, -3)
            Rectangle()
                .fill(scoreColor)
                .overlay(Rectangle().stroke(Color.white, lineWidth: 0.5))
                .overlay(
                    HStack {
                        Text("\(session.wordOne), \(session.wordTwo), \(session.wordThree)")
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(format: "%.1f", session.overallScore))
                            .foregroundColor(.white)
                    }
                    .padding()
                )
                .frame(height: 50)
                .padding(.bottom, 5)
        }
        .padding(.horizontal, 15)
    }
}

// #Preview {
//    TopSpotSessionCard(session: DummyData.generateDummySessions()[0])
// }
