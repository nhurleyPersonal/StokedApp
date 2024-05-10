//
//  SessionSubmissionForm.swift
//  Stoked
//
//  Created by Noah Hurley on 5/8/24.
//

import Combine
import SwiftUI

struct SessionSubmissionForm: View {
    @State private var sessionDatetime = Date()
    @State private var sessionLength = Double()
    @State private var sessionSpot = ""
    @State private var sessionWordOne = ""
    @State private var sessionWordTwo = ""

    @State private var sessionWordThree = ""
    @State private var sessionScore = Double()
    @State private var sessionWavecount: Int = 0
    @State private var sessionWavecountString: String = ""

    @State private var sessionCrowd = ""
    @State private var sessionBoard = ""
    @State private var sessionNotes = ""

    @State private var selectedTab = 0
    @State private var selectedCrowdOption = "Light"
    @State private var selectedBoardOption = "Shortboard"
    let crowdOptions = ["Light", "Moderate", "Crowded", "Overcrowded"]
    let surfLengthOptions = ["30 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3+ hours"]
    let crowdModifiers = ["Competitive", "Chill", "Local", "Aggro", "Longboard", "Shortboard"]
    let boardChoices = ["Shortboard", "Longboard", "Foamie", "Fish", "Gun", "Funboard", "Hybrid", "Soft Top", "Other"]
    let textboxColor = "373737"

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Text("Session Log")
                                .foregroundColor(.white)
                                .font(.system(size: 32))
                            DatePicker("Session Date", selection: $sessionDatetime, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .foregroundColor(.white)
                                .colorScheme(.dark)
                                .padding(.top, -10)

                            Rectangle()
                                .fill(Color.clear)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 200, height: 50)
                                .overlay(
                                    TabView(selection: $selectedTab) {
                                        ForEach(0 ..< surfLengthOptions.count) { index in
                                            Text(surfLengthOptions[index])
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .tabViewStyle(.page(indexDisplayMode: .never)) // <--- here
                                    .frame(width: 200, height: 50)
                                )
                                .padding(.bottom, 20)
                        }
                        Spacer()
                        SetSessionScoreView()
                    }

                    HStack {
                        Text("Spot:")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(.trailing, 10)

                        TextField("", text: $sessionSpot)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 15)
                    Text("Describe your session in three words")
                        .foregroundColor(.white)
                        .font(.system(size: 16))

                    HStack {
                        TextField("One", text: $sessionWordOne)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                        TextField("Two", text: $sessionWordTwo)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                        TextField("Three", text: $sessionWordThree)
                            .padding()
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 15)

                    ZStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)

                        Rectangle()
                            .frame(width: 150, height: 10)
                            .foregroundColor(Color(hex: "212121"))
                        Text("Extra Details (optional)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)

                    HStack {
                        VStack {
                            Text("Wave Count:")
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 16))

                            TextField("", text: $sessionWavecountString)
                                .onReceive(Just(sessionWavecountString)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        sessionWavecountString = filtered
                                    }
                                    sessionWavecount = Int(sessionWavecountString) ?? 0
                                }
                                .padding()
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .frame(width: 100)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 10)

                        VStack {
                            Text("Crowd:")
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 16))

                            Picker(selection: $selectedCrowdOption, label: Text("")) {
                                ForEach(crowdOptions, id: \.self) {
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

                        VStack {
                            Text("Board:")
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
                    Text("Extra Notes:")
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.trailing, 10)

                    TextEditor(text: $sessionNotes)
                        .padding()
                        .scrollContentBackground(.hidden)
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding()
                VStack {
                    Spacer()
                    Button(action: {
                        // Perform your action here
                        print("Button tapped!")
                    }) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                            Text("Submit Session")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue))
                    }
                }
            }
        }
    }
}

#Preview {
    SessionSubmissionForm()
}
