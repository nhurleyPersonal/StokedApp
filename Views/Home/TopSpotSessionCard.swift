//
//  TopSpotSessionCard.swift
//  Stoked
//
//  Created by Noah Hurley on 5/5/24.
//

import SwiftUI

struct TopSpotSessionCard: View {
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

    var body: some View {
        Rectangle()
            .fill(scoreColor)
            .overlay(Rectangle().stroke(Color.white, lineWidth: 0.5))
            .overlay(
                HStack {
                    Text("\(["John D.", "Jane S.", "Mike T.", "Emma B.", "Chris P."].randomElement() ?? "Unknown")")
                        .foregroundColor(.white)
                    Text("—")
                        .foregroundColor(.white)
                    Text("\(session.wordOne), \(session.wordTwo), \(session.wordThree)")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.1f", session.overallScore))
                        .foregroundColor(.white)
                }
                .padding()
            )
            .frame(height: 50)
            .padding(.horizontal, 15)
    }
}

#Preview {
    TopSpotSessionCard(session: DummyData.generateDummySessions()[0])
}
