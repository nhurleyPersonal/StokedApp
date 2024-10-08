//
//  WindDirectionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/3/24.
//

import SwiftUI

struct WindDirectionView: View {
    let surfData: SurfData
    let spot: Spot

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)

                Image(systemName: "arrow.up")
                    .rotationEffect(.degrees(Double(surfData.windDirection - 180)))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 10)
            Text(String(format: "%.1f mph, %.1f°", surfData.windSpeed, surfData.windDirection))
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

// #Preview {
//    WindDirectionView(surfData: DummyData.generateDummyTopSpot().surfData)
// }
