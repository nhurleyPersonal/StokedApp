//
//  FeedSpotView.swift
//  Stoked
//
//  Created by Noah Hurley on 6/29/24.
//
import Foundation
import SwiftUI

struct FeedSpotView: View {
    var sessions: [Session]
    var spot: Spot
    @State private var forecasts: [SurfData] = []
    @State private var isLoading = true // State to manage loading indicator
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            NavigationLink(destination: SpotView(spot: spot)) {
                HStack(alignment: .center) {
                    Text(spot.name)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)

                    Spacer()
                }
            }
            .padding(.leading, 20)
            .padding(.bottom, 10)

            if isLoading {
                ProgressView()
            } else {
                if let firstForecast = forecasts.first {
                    HStack(alignment: .top) {
                        Spacer()
                        SwellDirectionView(surfData: firstForecast, spot: spot)
                        Spacer()
                        WindDirectionView(surfData: firstForecast, spot: spot)
                        Spacer()
                        FeedSpotCircleScore(score: sessions.map { $0.overallScore }.reduce(0, +) / Double(sessions.count))
                        Spacer()
                    }
                    .padding(.bottom, 15)
                }
            }

            HStack {
                Text("Recent Sessions:")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.leading, 15)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 5)

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
                ForEach(sessions.prefix(3), id: \.id) { session in
                    NavigationLink(destination: SessionView(session: session)) {
                        SpotListSessionView(session: session)
                    }
                }
            }

            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            fetchForecastsForSpot(spotId: spot.id)
        }
    }

    private func fetchForecastsForSpot(spotId: String) {
        let currentDate = Date() // Set start date to now
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)! // Set end date to one hour in the future

        ForecastAPI.shared.getForecastsRange(spotId: spotId, startDate: currentDate, endDate: endDate) { forecasts, error in
            DispatchQueue.main.async {
                if let forecasts = forecasts {
                    self.forecasts = forecasts
                } else if let error = error {
                    print("Error loading forecasts: \(error)")
                }
                self.isLoading = false // Update loading state after data is fetched or an error occurs
            }
        }
    }
}
