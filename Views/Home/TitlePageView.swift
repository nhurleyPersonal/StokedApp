//
//  TitlePageView.swift
//  Stoked
//
//  Created by Noah Hurley on 7/7/24.
//

import SwiftUI

struct TitlePageView: View {
    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image("ColorBoards")
                    Spacer()
                    Image("StokedTitleScreen")

                    Text("WE LOVE TO SURF.")
                        .font(.system(size: 16))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(hex: "3D42B5"), Color(hex: "5BD7FE")]), startPoint: .leading, endPoint: .trailing))

                    Spacer()
                }
                .padding(.bottom, 30)

                Spacer()
            }
        }
    }
}

#Preview {
    TitlePageView()
}
