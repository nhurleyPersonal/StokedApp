import SwiftUI

struct SessionView: View {
    @Environment(\.theme) var theme

    @State private var isExpanded: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var surfDetailsIsExpanded = false

    var session: Session

    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: now)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"

        if date >= fiveDaysAgo {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            return "\(dayFormatter.string(from: date)) @ \(dateFormatter.string(from: date))"
        } else {
            let dateAndDayFormatter = DateFormatter()
            dateAndDayFormatter.dateFormat = "MMMM d @ h:mm"
            return dateAndDayFormatter.string(from: date)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text(session.spot.name)
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(session.user.firstName) \(session.user.lastName.prefix(1)).")
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top, 10)

                    HStack(alignment: .bottom) {
                        Text(formatDate(session.sessionDatetime))
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        Spacer()
                        HStack(alignment: .bottom) {
                            Text("\(session.waveCount)")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            Image("EndorsedIcon")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                        HStack(alignment: .bottom) {
                            Text("\(session.goodWaveCount)")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            Image("EndorsedIcon.yellow")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("1. \(session.wordOne)")
                                .padding(.bottom, 17)
                                .padding(.leading, 15)
                            Text("2. \(session.wordTwo)")
                                .padding(.bottom, 17)
                                .padding(.leading, 15)
                            Text("3. \(session.wordThree)")
                                .padding(.bottom, 17)
                                .padding(.leading, 15)
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        Spacer()
                        TopSpotCircleScore(score: session.overallScore)
                    }
                    Rectangle()
                        .frame(width: .infinity, height: 1)
                        .foregroundColor(.gray)
                    HStack(alignment: .top) {
                        SwellDirectionView(surfData: session.surfData[0])
                        Spacer()
                        WindDirectionView(surfData: session.surfData[0])
                        Spacer()
                        VStack(alignment: .center) {
                            TideSessionView()
                        }
                        .frame(width: 100, height: 100)
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                    VStack {
                        DisclosureGroup("Surf Details", isExpanded: $surfDetailsIsExpanded) {
                            VStack {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Wave Height:")
                                            .foregroundColor(.gray)
                                            .underline()
                                        Text("Chest-Head")
                                            .foregroundColor(.white)
                                            .padding(.bottom, 10)
                                        Text("Board:")
                                            .foregroundColor(.gray)
                                            .underline()
                                        Text("Mayem Subdriver")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Time between waves:")
                                            .foregroundColor(.gray)
                                            .underline()
                                        Text("Long (15-20m)")
                                            .padding(.bottom, 10)
                                        Text("Crowd:")
                                            .foregroundColor(.gray)
                                            .underline()
                                        Text("Light")
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .foregroundColor(.white)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Notes")
                                            .foregroundColor(.gray)
                                            .underline()
                                        Text("Lorem ipsum dolor sit amet. Quo quibusdam facilis id aliquid veniam ea quia ipsum eum officia rerum At eligendi rerum ut assumenda ipsam sit officia fugit. Et illo provident quo delectus deserunt quo sunt provident cum animi veniam eos mollitia")
                                            .padding(.bottom, 10)
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 10)

                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(hex: "1C1C1C"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitle("Session Log", displayMode: .inline)
    }
}

// struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionView(session: DummyData.generateDummySessions()[0])
//            .environment(\.theme, ThemeKey.defaultValue)
//    }
// }
