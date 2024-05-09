//
//  Session.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import Foundation

struct Session: Hashable, Identifiable, Codable {
    var id: String
    var spot: Spot
    var sessionDatetime: Date
    var sessionLength: Double
    var board: Board
    var surfData: SurfData
    var wordOne: String
    var wordTwo: String
    var wordThree: String
    var overallScore: Double
    var extraNotes: String
    var user: User
}
