import SwiftUI

extension Color {
    static let darkGreen = Color(red: 0, green: 0.5, blue: 0)
}

struct TopSpotsView: View {
    @Environment(\.theme) var theme
    @State private var isExpanded: Bool = false
    @State private var topDescriptions: String = ""
    @State private var isSessionViewPresented = false
    @State private var selectedSession: Session?

    var topSpot: TopSpot
    var topSpotSessions: [Session]

//    init(topSpot: TopSpot, ) {
//        self.topSpot = topSpot
//        _topDescriptions = State(initialValue: topSpot.descriptions.joined(separator: ", "))
//    }

    var fontSize: CGFloat {
        switch topSpot.name.count {
        case 1 ... 7:
            return 40
        case 8 ... 10:
            return 36
        case 11 ... 13:
            return 30
        default:
            return 32
        }
    }

    func getBackgroundColor(score: Double) -> Color {
        if score <= 3 {
            return Color(red: 67 / 255, green: 41 / 255, blue: 41 / 255)
        } else if score <= 5 {
            return Color(red: 81 / 255, green: 58 / 255, blue: 36 / 255)
        } else if score <= 7 {
            return Color(red: 69 / 255, green: 72 / 255, blue: 42 / 255)
        } else if score <= 9 {
            return Color(red: 59 / 255, green: 68 / 255, blue: 43 / 255)
        } else {
            return Color(red: 60 / 255, green: 37 / 255, blue: 78 / 255)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: getBackgroundColor(score: topSpot.overallScore), location: 0),
                        .init(color: .black, location: 3), // Midpoint at 50%
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                ))
                .padding(10)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(topSpot.name) // Top spot name
                        .font(.system(size: fontSize)) // Use custom font
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .padding(30)
                    Spacer()
                    TopSpotCircleScore(score: topSpot.overallScore)
                        .padding()
                }
                HStack {
                    Spacer()
                    DescriptionListView(description: topSpot.descriptions, score: topSpot.overallScore)
                    Spacer()
                }
                HStack(alignment: .top) {
                    Spacer()
                    SwellDirectionView(surfData: topSpot.surfData)
                        .padding(.horizontal, 10)
                    WindDirectionView(surfData: topSpot.surfData)
                        .padding(.horizontal, 10)

                    VStack {
                        Text("Low Tide:")
                        Text("12:42 / 12:08")
                        Text("")
                        Text("High Tide:")
                        Text("6:31 / 6:23")
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .font(.system(size: 14))

                    Spacer()
                }
                .padding(.vertical, 10)
                HStack {
                    Spacer()

                    Spacer()
                }

                NavigationLink(destination: selectedSession.map { SessionView(session: $0) }, isActive: $isSessionViewPresented) {
                    EmptyView()
                }
                if !topSpotSessions.isEmpty {
                    NavigationLink(destination: SessionView(session: topSpotSessions[0])) {
                        TopSpotSessionCard(session: topSpotSessions[0])
                    }
                    NavigationLink(destination: SessionView(session: topSpotSessions[0])) {
                        TopSpotSessionCard(session: topSpotSessions[0])
                    }
                    NavigationLink(destination: SessionView(session: topSpotSessions[0])) {
                        TopSpotSessionCard(session: topSpotSessions[0])
                    }
                }
            }

            HStack {
                Spacer()

                Spacer()
            }
            Spacer()
        }
    }
}

// struct TopSpotsView_Preview: PreviewProvider {
//    static var previews: some View {
//        HomeView(sessions: DummyData.generateDummySessions(), topSpots: DummyData.generateDummyTopSpots())
//    }
// }
