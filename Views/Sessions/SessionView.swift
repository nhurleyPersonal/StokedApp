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
        let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: now)!
        let sixDaysAgo = calendar.date(byAdding: .day, value: -6, to: now)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"

        if calendar.isDateInToday(date) {
            return "Today @ \(dateFormatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday @ \(dateFormatter.string(from: date))"
        } else if date >= sixDaysAgo {
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
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text(session.spot.name)
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            NavigationLink(destination: UserProfileView(user: session.user)) {
                                Text("@\(session.user.username)")
                                    .font(.system(size: 28))
                                    .foregroundColor(.gray)
                            }
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
                        Text(session.goodWaveCount != nil ? "\(session.waveCount!)" : "N/A")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        Image("EndorsedIcon")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    HStack(alignment: .bottom) {
                        Text(session.goodWaveCount != nil ? "\(session.goodWaveCount!)" : "N/A")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        Image("EndorsedIcon.yellow")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                }
                .padding(.top, -10)

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
                ZStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)

                    Rectangle()
                        .frame(width: 100, height: 10)
                        .foregroundColor(Color(.black))
                    Text("Surf Data")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                HStack(alignment: .top) {
                    Spacer()
                    VStack {
                        Text("Swell")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .underline()
                            .padding(.bottom, 20)
                            .padding(.leading, -10)

                        SwellDirectionView(surfData: session.surfData[0])
                    }
                    Spacer()

                    Divider()
                        .background(Color.gray)
                    Spacer()

                    VStack {
                        Text("Wind")
                            .foregroundColor(.white)
                            .underline()
                            .font(.system(size: 16))
                            .padding(.bottom, 20)

                        WindDirectionView(surfData: session.surfData[0])
                    }
                    Spacer()
                }
                .padding(.bottom, 10)

                TideSessionView(tideData: session.tideData, startDate: session.sessionDatetime, endDate: Date())
                    .frame(height: 100)
                    .padding(.top, 15)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                VStack {
                    DisclosureGroup("Extra Session Details", isExpanded: $surfDetailsIsExpanded) {
                        VStack {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text("Wave Height:")
                                        .foregroundColor(.gray)
                                        .underline()
                                    Text(session.waveHeight != nil ? "\(session.waveHeight!)" : "N/A")
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                    Text("Time between waves:")
                                        .foregroundColor(.gray)
                                        .underline()
                                    Text(session.timeBetweenWaves != nil ? "\(session.timeBetweenWaves!)" : "N/A")
                                        .padding(.bottom, 10)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("Crowd:")
                                        .foregroundColor(.gray)
                                        .underline()
                                    Text(session.crowd != nil ? "\(session.crowd!)" : "N/A")
                                        .padding(.bottom, 10)
                                    Text("Lineup:")
                                        .foregroundColor(.gray)
                                        .underline()
                                    Text(session.lineup != nil ? "\(session.lineup!)" : "N/A")
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .foregroundColor(.white)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Notes:")
                                        .foregroundColor(.gray)
                                        .underline()
                                    Text(session.extraNotes != nil ? "\(session.extraNotes!)" : "N/A")
                                        .padding(.bottom, 10)
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
        .navigationBarTitle("Session Log", displayMode: .inline)
    }
}

// struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionView(session: DummyData.generateDummySessions()[0])
//            .environment(\.theme, ThemeKey.defaultValue)
//    }
// }
