//
//  TopSpotsViewTest.swift
//  Stoked
//
//  Created by Noah Hurley on 5/2/24.
//

import SwiftUI

struct TopSpotsViewTest: View {
    @State private var isExpanded = false
    
    var passthroughTopSpot: TopSpot

    var body: some View {
        VStack{
            TopSpotsView(topSpot: passthroughTopSpot)
            TopSpotsView(topSpot: passthroughTopSpot)
            TopSpotsView(topSpot: passthroughTopSpot)
            Spacer()
        }
    }
}

#Preview {
    TopSpotsViewTest(passthroughTopSpot: DummyData.generateDummyTopSpot())
}
