//
//  ProfileSessionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/5/24.
//

import SwiftUI

struct ProfileSessionView: View {
    let session: Session
    @State private var frameHeight: CGFloat = 50 // Initial height, adjust as needed

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
            dateFormatter.dateFormat = "'Today @' h:mm a"
            return dateFormatter.string(from: date)
        }

        // Check if the date is yesterday
        if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "'Yesterday @' h:mm a"
            return dateFormatter.string(from: date)
        }

        // Calculate the number of days ago
        let daysAgo = calendar.dateComponents([.day], from: date, to: now).day!
        if daysAgo <= 5 {
            dateFormatter.dateFormat = "EEEE '@' h:mm a" // Day of the week with time
            return dateFormatter.string(from: date)
        }

        // Format the date as 'Month day' or 'Month day, year' if more than a year old
        let yearsAgo = calendar.dateComponents([.year], from: date, to: now).year!
        if yearsAgo >= 1 {
            dateFormatter.dateFormat = "MMMM d, yyyy '@' h:mm a"
        } else {
            dateFormatter.dateFormat = "MMMM d '@' h:mm a"
        }

        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(formatDateRelative(to: session.sessionDatetime))")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, -3)

            Rectangle()
                .fill(scoreColor)
                .frame(height: frameHeight)
                .overlay(Rectangle().stroke(Color.white, lineWidth: 0.5)) // Adding white outline
                .overlay(
                    VStack {
                        Spacer() // Pushes the content to center vertically

                        HStack(alignment: .center) {
                            Text("\(session.wordOne), \(session.wordTwo), \(session.wordThree)")
                                .foregroundColor(.white)
                                .padding(.bottom, -5)
                            Spacer()
                            SpotListScoreView(score: session.overallScore)
                        }

                        HStack(spacing: 5) {
                            if let waveCount = session.waveCount, waveCount > 0 {
                                Image("EndorsedIcon")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .aspectRatio(contentMode: .fit)
                                    .onAppear {
                                        frameHeight += 16 // Adjust frame height here
                                    }
                                Text("\(waveCount)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }

                            if let goodWaveCount = session.goodWaveCount, goodWaveCount > 0 {
                                Image("EndorsedIcon.yellow")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .aspectRatio(contentMode: .fit)
                                Text("\(goodWaveCount)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .onAppear {
                                        if session.waveCount == nil || session.waveCount == 0 {
                                            frameHeight += 16 // Adjust frame height here
                                        }
                                    }
                            }

                            Spacer()
                        }

                        if let waveHeight = session.waveHeight {
                            HStack {
                                Text("Wave Height: \(waveHeight)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .onAppear {
                                        frameHeight += 16 // Adjust frame height here
                                    }
                                Spacer()
                            }
                        }
                        if let extraNotes = session.extraNotes, extraNotes != "" {
                            HStack {
                                Text("Notes: \(extraNotes)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .onAppear {
                                        frameHeight += 16 // Adjust frame height here
                                    }
                                Spacer()
                            }
                        }

                        Spacer() // Ensures the content is centered vertically
                    }
                    .padding(.horizontal, 10)
                )

                .onAppear {
                    // Dynamically adjust frame height based on content
                    frameHeight = 50 // Adjust based on typical content height
                }
        }
        .padding(.horizontal, 15)
        .onDisappear {
            // Reset the frameHeight when the view disappears
            self.frameHeight = 60 // Reset to initial default height
        }
    }
}

// #Preview {
//    TopSpotSessionCard(session: DummyData.generateDummySessions()[0])
// }
