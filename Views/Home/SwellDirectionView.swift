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
                    .rotationEffect(.degrees(Double(surfData.primarySwellDirection - 180)))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 10)
            .padding(.bottom, 5)
            VStack {
                Text(String(format: "%.1f ft @ %.1fs %.1f°", surfData.primarySwellHeight, surfData.primarySwellPeriod, surfData.primarySwellDirection))
                    .font(.system(size: 10))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.green)
                ForEach(surfData.swellComponents, id: \.self) { component in
                    Text(String(format: "%.1f ft @ %.1fs %.1f°", component.wave_height, component.period, component.direction))
                        .font(.system(size: 10))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// #Preview {
//    SwellDirectionView(surfData: DummyData.generateDummyTopSpot().surfData)
// }
