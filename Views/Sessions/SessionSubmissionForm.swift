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
    @State private var sessionSpot: Spot?
    @State private var sessionWordOne = ""
    @State private var sessionWordTwo = ""

    @State private var sessionWordThree = ""
    @State private var sessionScore = Double()
    @State private var sessionWavecount: Int = 0
    @State private var sessionWavecountString: String = ""
    @State private var sessionGoodWavecount: Int = 0
    @State private var sessionGoodWavecountString: String = ""

    @State private var sessionCrowd = ""
    @State private var sessionBoard = ""
    @State private var sessionNotes = ""

    @State private var selectedTab = 0
    @State private var selectedCrowdOption = "----"
    @State private var selectedLineupOption = "----"
    @State private var selectedBoardOption = "----"
    @State private var selectedWaveHeightOption = "----"
    @State private var selectedTimeBetweenWaves = "----"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var allSpots: [Spot] = []

    @EnvironmentObject var currentUser: CurrentUser
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let crowdOptions = ["----", "Light", "Moderate", "Crowded", "Overcrowded"]
    let apparentWaveHeightOptions = ["----", "Ankle Slappers", "Knee-Thigh", "Thigh-Waist", "Waist-Chest", "Chest-Head", "Head-Head+", "Double Overhead", "XXL"]
    let timeBeteenWavesOptions = ["----", "<5 minutes", "5-10 minutes", "10-20 minutes", "20+ minutes"]
    let surfLengthOptions = ["30 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3+ hours"]
    let lineupOptions = ["----", "Competitive", "Chill", "Local", "Aggro"]
    let boardChoices = ["----", "Shortboard", "Longboard", "Foamie", "Fish", "Gun", "Funboard", "Hybrid", "Soft Top", "Other"]
    let textboxColor = "373737"

    func createSession() {
        if currentUser.user != nil {
            // Check if required fields are filled
            // if sessionDatetime == Date() || sessionLength == 0 || sessionWordOne.isEmpty || sessionWordTwo.isEmpty || sessionWordThree.isEmpty {
            //     alertMessage = "Please fill in all required fields."
            //     showingAlert = true
            //     return
            // }
            SessionAPI.shared.currentUser = currentUser
            let crowd = selectedCrowdOption == "----" ? nil : selectedCrowdOption
            let board = selectedBoardOption == "----" ? nil : selectedBoardOption
            let lineup = selectedLineupOption == "----" ? nil : selectedLineupOption
            let waveHeight = selectedWaveHeightOption == "----" ? nil : selectedWaveHeightOption
            let timeBetweenWaves = selectedTimeBetweenWaves == "----" ? nil : selectedTimeBetweenWaves

            let session = PreAddSession(
                spot: sessionSpot?.id ?? "",
                sessionDatetime: sessionDatetime,
                sessionLength: sessionLength,
                wordOne: sessionWordOne,
                wordTwo: sessionWordTwo,
                wordThree: sessionWordThree,
                overallScore: sessionScore,
                waveCount: sessionWavecount,
                goodWaveCount: sessionGoodWavecount,
                crowd: selectedCrowdOption,
                lineup: lineup,
                waveHeight: waveHeight,
                timeBeteenWaves: timeBetweenWaves,
                extraNotes: sessionNotes,
                user: currentUser.user!
            )
            SessionAPI.shared.addSession(session: session)
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                DatePicker("Session Date", selection: $sessionDatetime, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .foregroundColor(.white)
                                    .colorScheme(.dark)
                                    .padding(.top, 10)

                                Rectangle()
                                    .fill(Color.clear)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 200, height: 50)
                                    .overlay(
                                        TabView(selection: $selectedTab) {
                                            ForEach(0 ..< surfLengthOptions.count) { index in
                                                Text(surfLengthOptions[index])
                                                    .foregroundColor(.white)
                                                    .tag(index)
                                            }
                                        }
                                        .tabViewStyle(.page(indexDisplayMode: .never)) // <--- here
                                        .frame(width: 200, height: 50)
                                        .onChange(of: selectedTab) { newValue in
                                            sessionLength = 0.5 * Double(newValue + 1)
                                        }
                                    )
                                    .padding(.bottom, 20)
                            }
                            Spacer()
                            SetSessionScoreView(sessionScore: $sessionScore)
                        }

                        HStack(alignment: .top) {
                            Text("Spot:")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.trailing, 10)
                                .padding(.top, 20)

                            SessionSubmissionSpotSearch(allSpots: allSpots, selectedSpot: $sessionSpot)
                                .padding(.trailing, 10)
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
                            .padding(.trailing, 20)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Good Wave Count:")
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .lineLimit(1)

                                TextField("", text: $sessionGoodWavecountString)
                                    .onReceive(Just(sessionGoodWavecountString)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            sessionGoodWavecountString = filtered
                                        }
                                        sessionGoodWavecount = Int(sessionGoodWavecountString) ?? 0
                                    }
                                    .padding()
                                    .background(Color(hex: textboxColor))
                                    .border(Color.white, width: 0.5)
                                    .frame(width: 100)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Crowd:")
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Picker(selection: $selectedCrowdOption, label: Text("")) {
                                    ForEach(crowdOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .frame(height: 55)
                                .frame(minWidth: 100)
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                                .accentColor(.white)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Linuep:")
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Picker(selection: $selectedLineupOption, label: Text("")) {
                                    ForEach(lineupOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .frame(height: 55)
                                .frame(minWidth: 100)
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                                .accentColor(.white)
                            }
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Approx. Wave Height:")
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Picker(selection: $selectedWaveHeightOption, label: Text("")) {
                                    ForEach(apparentWaveHeightOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .frame(height: 55)
                                .frame(minWidth: 100)
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                                .accentColor(.white)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Lull Length:")
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Picker(selection: $selectedTimeBetweenWaves, label: Text("")) {
                                    ForEach(timeBeteenWavesOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .frame(height: 55)
                                .frame(minWidth: 100)
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                                .accentColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 10)

                        Text("Extra Notes:")
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(.trailing, 10)

                        TextEditor(text: $sessionNotes)
                            .padding()
                            .frame(height: 100)
                            .scrollContentBackground(.hidden)
                            .background(Color(hex: textboxColor))
                            .border(Color.white, width: 0.5)
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding()
                }
            }
            .onAppear {
                SessionAPI.shared.getAllSpots { spots, error in
                    if let spots = spots {
                        self.allSpots = spots
                    } else {
                        print("Error getting spots: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
            .navigationBarTitle("Session Log", displayMode: .inline)
            VStack {
                Spacer()
                Button(action: {
                    let session = createSession()
                    print("Session created: \(session)")
                    currentUser.shouldRefresh = true
                    self.presentationMode.wrappedValue.dismiss()

                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                        Text("Submit Session")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.green))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SessionSubmissionForm()
}
