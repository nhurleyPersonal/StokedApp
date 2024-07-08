//
//  SearchResultsView.swift
//  Stoked
//
//  Created by Noah Hurley on 6/2/24.
//

import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    let spots: [Spot]
    let users: [User]
    @State private var selection = 0

    var body: some View {
        VStack {
            Picker("Results", selection: $selection) {
                Text("Spots").tag(0)
                Text("Users").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)

            if selection == 1 {
                ScrollView {
                    VStack {
                        ForEach(users, id: \.self) { user in
                            NavigationLink(destination: UserProfileView(user: user)) {
                                UserCard(user: user)
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
            } else if selection == 0 {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(spots, id: \.self) { spot in
                            NavigationLink(destination: SpotView(spot: spot)) {
                                SpotCard(spot: spot)
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
                .background(Color(hex: "212121"))
            }
        }
    }
}

struct UserCard: View {
    var user: User
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text("@\(user.username)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .padding(.bottom, 5)
                }
                Spacer()
            }
            Divider()
                .foregroundColor(.gray)
        }
        .background(Color(hex: "212121"))
    }
}

struct SpotCard: View {
    var spot: Spot
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "mappin.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                Text(spot.name)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.bottom, 5)
                Spacer()
            }
            Divider()
                .foregroundColor(.gray)
        }
        .background(Color(hex: "212121"))
    }
}
