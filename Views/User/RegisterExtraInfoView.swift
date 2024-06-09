//
//  RegisterExtraInfoView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/29/24.
//

import SwiftUI

struct RegisterExtraInfoView: View {
    @Binding var tagline: String
    @Binding var skillLevel: String
    @Binding var boardName: String
    @Binding var boardLength: String
    @Binding var boardVolume: String
    @Binding var selectedBoardOption: String

    @Binding var homeSpot: Spot?
    @State private var allSpots: [Spot] = []
    let textboxColor = "373737"

    let skillLevels = ["Beginner", "Advanced Beginner", "Intermediate", "Advanced", "Sponsored/JJF"]
    let boardChoices = ["Longboard", "Shortboard Thruster", "Twin Fin", "Fish", "Funky/Unique",
                        "Midlength", "Foamie", "Gun", "Hybrid", "Other"]

    var register: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: -3) {
                    Text("Quick Bio")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("(Optional, but encouraged)")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    Text("Tagline")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text("A few words about you as a surfer")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    TextField("Tagline", text: $tagline)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    Text("Skill Level")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text("Where you would place you surfing ability")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Picker("Skill Level", selection: $skillLevel) {
                        ForEach(skillLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .border(Color.gray, width: 1)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    Text("Home Break")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    Text("The spot you surf the most")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    SessionSubmissionSpotSearch(allSpots: allSpots, selectedSpot: $homeSpot)
                }
                .padding(.bottom, 15)

                ZStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)

                    Rectangle()
                        .frame(width: 170, height: 10)
                        .foregroundColor(Color(hex: "212121"))
                    Text("Add a board you like to ride")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)

                VStack(alignment: .leading) {
                    Text("Board Name")
                        .foregroundColor(.white)
                        .font(.system(size: 16))

                    TextField("Make - Model", text: $boardName)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                HStack(alignment: .bottom) {
                    VStack(alignment: .trailing) {
                        Text("Length")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 16))

                        TextField("Ft'in\"", text: $boardLength)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)

                    VStack(alignment: .center) {
                        Text("Volume")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 16))

                        TextField("(L)", text: $boardVolume)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)

                    VStack(alignment: .center) {
                        Text("Type:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 16))

                        Picker(selection: $selectedBoardOption, label: Text("")) {
                            ForEach(boardChoices, id: \.self) {
                                Text($0)
                            }
                        }
                        .frame(height: 55)
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .accentColor(.white)
                    }
                    .padding(.bottom, 10)
                }
                Button(action: {
                    // Perform the action of submitting the form here
                    register()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// #Preview {
//    RegisterExtraInfoView()
// }
