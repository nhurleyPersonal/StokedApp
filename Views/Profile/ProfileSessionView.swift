//
//  ProfileSessionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/11/24.
//

import SwiftUI

struct ProfileSessionView: View {
    var session: Session
    var boxHeight = 130.0

    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "353535"))
                .frame(height: boxHeight)
                .padding()
            VStack {
                HStack(alignment: .bottom) {
                    Text(session.spot.name)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .padding(.leading, 25)
                        .padding(.top, 10)
                    Text(formatTime(session.sessionDatetime))
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .padding(.top, 10)
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("1.   \(session.wordOne)")
                        Text("2.   \(session.wordTwo)")
                        Text("3.   \(session.wordThree)")

                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    Spacer()
                    Spacer()
                }

                Spacer()
            }
            .frame(height: boxHeight)
            HStack {
                Spacer()
                Spacer()
                VStack {
                    HStack {
                        Image("EndorsedIcon")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 10)
                            .padding(.top, 15)
                        Text(session.goodWaveCount != nil ? "\(session.waveCount!)" : "N/A")
                            .foregroundColor(.white)
                            .padding(.top, 15)
                    }
                    HStack {
                        Image("EndorsedIcon.yellow")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 10)

                        Text(session.goodWaveCount != nil ? "\(session.goodWaveCount!)" : "N/A")
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 5)

                Spacer()
                TopSpotCircleScore(score: session.overallScore)
                    .padding(.trailing, 25)
            }
        }
    }
}

// #Preview {
//    ProfileSessionView(session: DummyData.generateDummySessions()[0])
// }
