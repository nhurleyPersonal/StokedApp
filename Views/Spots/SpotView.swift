//
//  SpotView.swift
//  Stoked
//
//  Created by Noah Hurley on 6/3/24.
//

import MapKit // Import MapKit
import SwiftUI

struct SpotView: View {
    @EnvironmentObject var currentUser: CurrentUser
    var spot: Spot
    @State private var selectedDate: Date = .init() // Default to today
    @State private var selectedTime: Date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()), minute: 0, second: 0, of: Date()) ?? Date() // Default to the current time but to the beginning of the hour
    let today = Date()
    @State private var isFavorite: Bool = false

    // Computed property for endDate
    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: 7, to: today)!
    }

    // Computed property to format the selected time
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }

    // Computed property to find the closest SurfData entry
    var closestForecast: SurfData? {
        let selectedDateTimeInterval = Calendar.current.startOfDay(for: selectedDate).addingTimeInterval(selectedTime.timeIntervalSince(Calendar.current.startOfDay(for: selectedTime))).timeIntervalSince1970
        let closest = forecasts.min(by: { abs($0.date - selectedDateTimeInterval) < abs($1.date - selectedDateTimeInterval) })
        print(closest)
        return closest
    }

    @State private var sessions: [Session] = []
    @State private var forecasts: [SurfData] = []
    @State private var tides: [TideData] = []
    @State private var tideCheckDate: Date = .init()
    @State private var isLoading = true // Add a loading state
    @State private var tidesLoading = true // Initialize as true to show loading initially
    @FocusState private var datePickerFocused: Bool // Add a focus state for the date picker

    // Add a state for map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedSection = 0 // Add state for section selection

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    ZStack {
                        // Map view with marker
                        Map(coordinateRegion: $region, interactionModes: [], annotationItems: [spot]) { place in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(
                                latitude: Double(place.lat) ?? 0, // Convert string to Double
                                longitude: Double(place.lon) ?? 0 // Convert string to Double
                            )) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .imageScale(.large)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 300) // Set a fixed height
                        .edgesIgnoringSafeArea(.top) // Allow the map to extend under the top edge (navigation bar)
                        .padding(.top, -100)
                        // Semi-transparent overlay
                        Color.black.opacity(0.3) // Adjust opacity here
                            .edgesIgnoringSafeArea(.all)
                            .padding(.top, -100)
                        HStack {
                            Text(spot.name)
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .padding(.top, 100)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    }
                    Picker("View", selection: $selectedSection) {
                        Text("Surf Data").tag(0)
                        Text("Sessions").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top, -15)
                    .padding(.horizontal, 10)

                    if selectedSection == 0 {
                        HStack(alignment: .top) {
                            Spacer()

                            // Swell Direction View
                            VStack {
                                Text("Swell")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .underline()
                                    .padding(.bottom, 10)
                                    .padding(.leading, -10)

                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5)
                                        .padding()
                                } else {
                                    if let forecast = closestForecast {
                                        SwellDirectionView(surfData: forecast, spot: spot)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity) // Take up half the width

                            Divider()
                                .background(Color.gray)

                            // Wind Direction View
                            VStack {
                                Text("Wind")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .underline()
                                    .padding(.bottom, 10)
                                    .padding(.leading, -10)

                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5)
                                        .padding()
                                } else {
                                    if let forecast = closestForecast {
                                        WindDirectionView(surfData: forecast, spot: spot)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity) // Take up half the width

                            Spacer()
                        }
                        .padding(.top, 10)
                        VStack {
                            HStack(alignment: .center) {
                                DatePicker("Session Date", selection: $selectedDate, in: today ... endDate, displayedComponents: [.date])
                                    .labelsHidden()
                                    .foregroundColor(.white)
                                    .preferredColorScheme(.dark)
                                    .focused($datePickerFocused)
                                    .onChange(of: selectedDate) { newDate in
                                        tideCheckDate = newDate // Update tideCheckDate to the new selected date
                                        fetchTidesByDay() // Fetch new tide data for the updated date
                                        datePickerFocused = false // Remove focus when date is selected
                                    }

                                Text("@ \(formattedTime)") // Use the formatted selected time
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(.leading, 3)
                                Spacer()
                            }
                            .padding(.leading, 20)

                            GeometryReader { geometry in
                                TimeTouchBar(selectedTime: $selectedTime)
                                    .frame(width: geometry.size.width * 0.9)
                                    .centerHorizontally()
                            }
                        }
                        .padding(.bottom, 30)

                        VStack {
                            // Check if data is loading
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5)
                                    .padding()
                            } else {
                                if !tides.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Tides")
                                            .foregroundColor(.white)
                                            .underline()
                                            .font(.system(size: 16))
                                            .padding(.leading, 10)

                                        // Check if data is loading
                                        if tidesLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .scaleEffect(1.5)
                                                .padding()
                                        } else {
                                            if !forecasts.isEmpty {
                                                TideSessionView(tideData: tides[0])
                                                    .frame(height: 80)
                                                    .padding(.horizontal, 10)
                                                    .padding(.top, -40)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 10)

                    } else {
                        // Sessions Section
                        VStack {
                            if sessions.isEmpty {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("No recent sessions")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 20))
                                        Text("Surfed here recently? Add a session.")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                        NavigationLink(destination: SessionSubmissionForm(initialSpot: spot)) {
                                            Image(systemName: "plus.circle")
                                                .font(.system(size: 30))
                                                .foregroundColor(.green)
                                        }
                                        .padding(.top, 5)
                                    }

                                    Spacer()
                                }
                            } else {
                                ForEach(sessions.sorted(by: { $0.sessionDatetime > $1.sessionDatetime }), id: \.self) { session in
                                    NavigationLink(destination: SessionView(session: session)) {
                                        SpotListSessionView(session: session)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.width < 0, selectedSection < 1 {
                            // Swipe Left
                            withAnimation {
                                selectedSection += 1
                            }
                        } else if value.translation.width > 0, selectedSection > 0 {
                            // Swipe Right
                            withAnimation {
                                selectedSection -= 1
                            }
                        }
                    }
                )
            }
            .transparentNavigationBar()
            .navigationBarItems(trailing: HStack {
                NavigationLink(destination: SessionSubmissionForm(initialSpot: spot)) {
                    Image(systemName: "text.badge.plus")
                        .foregroundColor(.white)
                }
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }

            })
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarItems(leading: CustomBackButton()) // Use the custom back button
            .onAppear {
                fetchSessionsForSpot()
                fetchForecastsForSpot()
                fetchTidesByDay()
                checkIfFavorite(spot: spot)

                // Set the initial region around the spot
                region.center = CLLocationCoordinate2D(latitude: Double(spot.lat) ?? 0, longitude: Double(spot.lon) ?? 0)
            }
        }
    }

    private func fetchSessionsForSpot() {
        SessionAPI().getSessionsBySpot(spot: spot) { sessions, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error getting sessions: \(error)")
                } else if let sessions = sessions {
                    self.sessions = sessions
                }
            }
        }
    }

    private func fetchForecastsForSpot() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        ForecastAPI.shared.getForecastsRange(spotId: spot.id, startDate: currentDate, endDate: endDate) { forecasts, error in
            DispatchQueue.main.async {
                if let forecasts = forecasts {
                    self.forecasts = forecasts
                    self.isLoading = false // Update loading state after data is fetched
                } else if let error = error {
                    print("Error loading forecasts: \(error)")
                    self.isLoading = false // Update loading state even if there's an error
                }
            }
        }
    }

    private func fetchTidesByDay() {
        tidesLoading = true // Set loading to true when starting to fetch
        ForecastAPI.shared.searchTides(tideStation: spot.tideStation, date: tideCheckDate) { tides, error in
            DispatchQueue.main.async {
                if let tides = tides {
                    self.tides = tides
                    self.tidesLoading = false // Set loading to false after data is fetched
                } else if let error = error {
                    print("Error loading tides: \(error)")
                    self.tidesLoading = false // Set loading to false even if there's an error
                }
            }
        }
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            UserAPI.shared.addFavoriteSpot(spot: spot) { success in
                if !success {
                    // Handle error: revert state if needed
                    isFavorite = false
                }
            }

        } else {
            UserAPI.shared.removeFavoriteSpot(spot: spot) { success, _ in
                if !success {
                    // Handle error: revert state if needed
                    isFavorite = true
                }
            }
        }
    }

    private func checkIfFavorite(spot: Spot) {
        // First, check if the spot is already in the local favorite spots
        if currentUser.favoriteSpots.contains(where: { $0.id == spot.id }) {
            isFavorite = true
        } else {
            // If not found locally, fetch from the server
            UserAPI.shared.getFavoriteSpots { spots, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching favorite spots: \(error.localizedDescription)")
                        // Consider handling the error more gracefully here
                    } else if let spots = spots {
//                        currentUser.favoriteSpots = spots
//                        // Check again if the spot is in the newly fetched list
                        self.isFavorite = spots.contains(where: { $0.id == spot.id })
                    }
                }
            }
        }
    }
}

extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}
