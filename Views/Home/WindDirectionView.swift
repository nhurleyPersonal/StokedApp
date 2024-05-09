//
//  WindDirectionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/3/24.
//

import SwiftUI

struct WindDirectionView: View {
    let surfData: SurfData

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
            Text(String(format: "%.1f kts, %d°", surfData.windSpeed, surfData.windDirection))
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WindDirectionView(surfData: DummyData.generateDummyTopSpot().surfData)
}
