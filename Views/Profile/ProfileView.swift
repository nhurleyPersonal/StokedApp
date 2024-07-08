//
//  ProfileView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/11/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var showingSubmissionForm = false
    @ObservedObject var currentUser: CurrentUser
    @Binding var isLoggedIn: Bool
    @State private var currentUserSessions: [Session] = []

    var homebreak: String {
        if let homebreakName = currentUser.user?.homeSpot?.name {
            return "Loves to surf at \(homebreakName)"
        } else {
            return "No Home Break Set"
        }
    }

    var groupedSessions: [Date: [Session]] {
        let grouped = Dictionary(grouping: currentUserSessions) { midnightDate(from: $0.sessionDatetime) }
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
        } else
        if daysAgo < 5 {
            return "\(daysAgo) days ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }

    private func fetchSessions() {
        if currentUser.user != nil {
            SessionAPI().getSessionsByUser(user: currentUser.user!) { sessions, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error getting sessions: \(error)")
                    } else if let sessions = sessions {
                        self.currentUserSessions = sessions
                    }
                    self.currentUser.shouldRefresh = false
                }
            }
        }
    }

    var body: some View {
        let displayName = currentUser.user.map { "\($0.firstName) \($0.lastName)" } ?? "User"
        let username = currentUser.user?.username ?? ""
        let tagline = currentUser.user?.tagline ?? ""
        let sessionCount = currentUserSessions.count
        let lastSessionDate = currentUserSessions.first?.sessionDatetime ?? nil
        let goodWaveCount = currentUserSessions.compactMap { $0.goodWaveCount }.reduce(0, +)

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
                                NavigationLink(destination: ProfileSettingsView()) {
                                    Text("Edit Profile")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 3)
                                        .padding(.horizontal, 5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                }
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
                        VStack {
                            ForEach(groupedSessions[date]!, id: \.self) { session in
                                NavigationLink(destination: SessionView(session: session)) {
                                    ProfileSessionView(session: session)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onReceive(currentUser.$shouldRefresh) { _ in
            if currentUser.shouldRefresh {
                fetchSessions()
            }
        }
        .refreshable {
            currentUser.shouldRefresh = true
            fetchSessions()
        }
    }
}

// #Preview {
//     ProfileView()
// }
