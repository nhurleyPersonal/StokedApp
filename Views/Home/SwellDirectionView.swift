//
//  SwellDirectionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/3/24.
//

import SwiftUI

struct SwellDirectionView: View {
    let surfData: SurfData

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)

                Image(systemName: "arrow.up")
                    .rotationEffect(.degrees(Double(surfData.swellDirection - 180)))
                    .foregroundColor(.white)
            }
            Text(String(format: "%.1f ft @ %.1f s\n%d°", surfData.swellHeight, surfData.swellPeriod, surfData.swellDirection))
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SwellDirectionView(surfData: DummyData.generateDummyTopSpot().surfData)
}
