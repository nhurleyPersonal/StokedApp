//
//  SessionSubmissionForm.swift
//  Stoked
//
//  Created by Noah Hurley on 5/8/24.
//

import Combine
import Lottie
import SwiftUI

struct SessionSubmissionForm: View {
    @State private var sessionDatetime = Date()
    @State private var sessionLength: Double?
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

    @State private var showSuccessAnimation = false
    @State private var showReturnedSession = false // Add this line

    @EnvironmentObject var currentUser: CurrentUser
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @FocusState private var isInputActive: Bool

    @State private var selectedSession: Session? = nil

    let crowdOptions = ["----", "Light", "Moderate", "Crowded", "Overcrowded"]
    let apparentWaveHeightOptions = ["----", "Ankle Slappers", "Knee-Thigh", "Thigh-Waist", "Waist-Chest", "Chest-Head", "Head-Head+", "Double Overhead", "XXL"]
    let timeBeteenWavesOptions = ["----", "<5 minutes", "5-10 minutes", "10-20 minutes", "20+ minutes"]
    let surfLengthOptions: [(String, Double?)] = [
        ("----", nil),
        ("30 minutes", 0.5),
        ("1 hour", 1.0),
        ("1.5 hours", 1.5),
        ("2 hours", 2.0),
        ("2.5 hours", 2.5),
        ("3+ hours", 3.0),
    ]
    let lineupOptions = ["----", "Competitive", "Chill", "Local", "Aggro"]
    let boardChoices = ["----", "Shortboard", "Longboard", "Foamie", "Fish", "Gun", "Funboard", "Hybrid", "Soft Top", "Other"]
    let textboxColor = "373737"

    // Add an initializer to accept an optional Spot
    init(initialSpot: Spot? = nil) {
        _sessionSpot = State(initialValue: initialSpot)
    }

    func createSession() {
        if currentUser.user != nil {
            // Check if sessionLength is non-nil and unwrap it
            guard let unwrappedSessionLength = sessionLength else {
                // Handle the case where sessionLength is nil, e.g., set a default value or show an error
                alertMessage = "Please select a valid session length."
                showingAlert = true
                return
            }

            SessionAPI.shared.currentUser = currentUser
            let crowd = selectedCrowdOption == "----" ? nil : selectedCrowdOption
            let board = selectedBoardOption == "----" ? nil : selectedBoardOption
            let lineup = selectedLineupOption == "----" ? nil : selectedLineupOption
            let waveHeight = selectedWaveHeightOption == "----" ? nil : selectedWaveHeightOption
            let timeBetweenWaves = selectedTimeBetweenWaves == "----" ? nil : selectedTimeBetweenWaves

            let session = PreAddSession(
                spot: sessionSpot?.id ?? "",
                sessionDatetime: sessionDatetime,
                sessionLength: unwrappedSessionLength, // Use the unwrapped session length
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
            SessionAPI.shared.addSession(session: session) { success, createdSession in
                if success, let createdSession = createdSession {
                    withAnimation {
                        showSuccessAnimation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSuccessAnimation = false
                        }
                        self.selectedSession = createdSession // Set the selected session to navigate
                        self.showReturnedSession = true // Set showReturnedSession to true
                    }
                } else {
                    alertMessage = "Failed to add session. Please try again."
                    showingAlert = true
                }
            }
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isInputActive = false // This will dismiss the keyboard
                }
            ScrollView {
                ZStack {
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                VStack {
                                    DatePicker("Session Date", selection: $sessionDatetime, displayedComponents: [.date, .hourAndMinute])
                                        .labelsHidden()
                                        .foregroundColor(.white)
                                        .colorScheme(.dark)

                                    Picker("Select Session Length", selection: $sessionLength) {
                                        ForEach(surfLengthOptions, id: \.0) { option in
                                            Text(option.0).tag(option.1 as Double?) // Ensure the tag is explicitly cast to Double?
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 200, height: 100)
                                    .clipped()
                                    .padding(.bottom, 20)
                                    .padding(.top, -10)
                                }
                                Spacer()
                                VStack {
                                    TopSpotCircleScore(score: sessionScore)
                                        .padding(.top, 10)
                                    Spacer()
                                }
                            }

                            SetSessionScoreView(sessionScore: $sessionScore)
                                .padding(.top, -10)
                        }

                        HStack(alignment: .top) {
                            Text("Spot:")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.trailing, 10)
                                .padding(.top, 20)

                            // Use the initial spot if provided
                            SessionSubmissionSpotSearch(allSpots: allSpots, selectedSpot: $sessionSpot)
                                .padding(.trailing, 10)
                        }
                        .padding(.bottom, 15)
                        Text("Describe your session in three words")
                            .foregroundColor(.white)
                            .font(.system(size: 16))

                        HStack {
                            TextField("One", text: $sessionWordOne)
                                .focused($isInputActive)
                                .padding()
                                .contentShape(Rectangle()) // Makes the entire area clickable
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                            TextField("Two", text: $sessionWordTwo)
                                .focused($isInputActive)
                                .padding()
                                .contentShape(Rectangle()) // Makes the entire area clickable
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                            TextField("Three", text: $sessionWordThree)
                                .focused($isInputActive)
                                .padding()
                                .contentShape(Rectangle()) // Makes the entire area clickable
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
                                    .contentShape(Rectangle())
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                TextField("", text: $sessionWavecountString)
                                    .focused($isInputActive)
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
                                    .focused($isInputActive)
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
                            .focused($isInputActive)
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
            .gesture(
                DragGesture().onChanged { _ in
                    isInputActive = false // Dismiss the keyboard when starting to drag
                }
            )
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
        .overlay(
            Group {
                if showSuccessAnimation {
                    LottieView(animation: .named("checkmark-animation"))
                        .playing()
                }
            }
        )
        .background(
            Group {
                if let session = selectedSession {
                    NavigationLink(
                        destination: SessionView(session: session),
                        isActive: $showReturnedSession, // Use showReturnedSession to trigger navigation
                        label: { EmptyView() }
                    )
                }
            }
        )
    }
}

#Preview {
    SessionSubmissionForm()
}
