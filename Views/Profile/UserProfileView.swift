import SwiftUI

struct UserProfileView: View {
    var user: User
    @State private var userSessions: [Session] = []

    var homebreak: String {
        if let homebreakName = user.homeSpot?.name {
            return "Loves to surf at \(homebreakName)"
        } else {
            return "No Home Break Set"
        }
    }

    var groupedSessions: [Date: [Session]] {
        let grouped = Dictionary(grouping: userSessions) { midnightDate(from: $0.sessionDatetime) }
        return grouped
    }

    func midnightDate(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }

    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let daysAgo = calendar.dateComponents([.day], from: date, to: Date()).day!

        if daysAgo == 0 {
            return "Today"
        } else if daysAgo == 1 {
            return "Yesterday"
        } else if daysAgo < 5 {
            return "\(daysAgo) days ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }

    private func fetchSessions() {
        SessionAPI().getSessionsByUser(user: user) { sessions, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error getting sessions: \(error)")
                } else if let sessions = sessions {
                    self.userSessions = sessions
                }
            }
        }
    }

    var body: some View {
        let displayName = "\(user.firstName) \(user.lastName)"
        let username = user.username
        let tagline = user.tagline ?? ""
        let sessionCount = userSessions.count
        let lastSessionDate = userSessions.first?.sessionDatetime ?? nil
        let goodWaveCount = userSessions.reduce(0) { $0 + $1.goodWaveCount }

        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .padding(.trailing, 20)

                            VStack(alignment: .leading) {
                                Text(displayName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                Text("@\(username)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }

                            Spacer()
                        }
                        .padding(.bottom, 10)

                        Text("\"\(tagline)\"")
                            .foregroundColor(.white)
                            .font(.system(size: 20))

                        Text("Last Session: \(lastSessionDate != nil ? formatDate(lastSessionDate!) : "No sessions yet")").foregroundColor(.green)
                            .font(.system(size: 16))

                        Text(homebreak)
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                            .italic()

                        HStack {
                            HStack {
                                Image(systemName: "surfboard")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(sessionCount) Sessions Logged")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            HStack {
                                Image("EndorsedIcon.yellow")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(goodWaveCount) Good Waves")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }

                            Spacer()
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)

                    ForEach(groupedSessions.keys.sorted(by: { $0.compare($1) == .orderedDescending }), id: \.self) { date in
                        VStack(spacing: -10) {
                            HStack {
                                Text(formatDate(date))
                                    .foregroundColor(.white)
                                    .padding(.leading, 10)
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 20)
                            }
                            ForEach(groupedSessions[date]!, id: \.self) { session in
                                NavigationLink(destination: SessionView(session: session)) {
                                    ProfileSessionView(session: session)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
        .onAppear {
            fetchSessions()
        }
        .refreshable {
            fetchSessions()
        }
    }
}
