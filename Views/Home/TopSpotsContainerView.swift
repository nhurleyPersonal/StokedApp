import SwiftUI

struct TopSpotsContainerView: View {
    var currentPage: Binding<Int>
    var topSpotSessions: [Session]
    let dummyTopSpot: TopSpot

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)

                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0 ..< 3) { index in
                                TopSpotsView(topSpot: self.dummyTopSpot, topSpotSessions: self.topSpotSessions)
                                    .frame(width: geometry.size.width)
                                    .tag(index)
                            }
                        }
                    }
                    .content.offset(x: -CGFloat(self.currentPage.wrappedValue) * geometry.size.width)
                    .frame(width: geometry.size.width, alignment: .leading)
                    .gesture(
                        DragGesture().onEnded { value in
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.currentPage.wrappedValue > 0 {
                                withAnimation {
                                    self.currentPage.wrappedValue -= 1
                                }
                            } else if value.predictedEndTranslation.width < -geometry.size.width / 2, self.currentPage.wrappedValue < 2 {
                                withAnimation {
                                    self.currentPage.wrappedValue += 1
                                }
                            }
                        }
                    )
                    .mask(
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
                    )
                }
                .zIndex(0)

                Text("Top Spots Today")
                    .foregroundColor(.white)
                    .padding(.horizontal, 3)
                    .background(Color(hex: "212121"))
                    .offset(x: -UIScreen.main.bounds.width * 0.325, y: -UIScreen.main.bounds.height * 0.325)
                    .zIndex(1)
            }

            HStack {
                ForEach(0 ..< 3) { index in
                    Circle()
                        .fill(index == currentPage.wrappedValue ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                        .padding(2)
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width) // Ensure the entire container does not exceed the screen width
    }
}
