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
    var wordOne: String
    var wordTwo: String
    var wordThree: String
    var overallScore: Double
    var waveCount: Int?
    var goodWaveCount: Int?
    var crowd: String?
    var lineup: String?
    var waveHeight: String?
    var timeBetweenWaves: String?
    var extraNotes: String?
    var user: User
    var surfData: [SurfData]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case spot, sessionDatetime, sessionLength,
             wordOne, wordTwo, wordThree, overallScore,
             waveCount, goodWaveCount, crowd, lineup, waveHeight, timeBetweenWaves, extraNotes, user, surfData
    }
}

struct PreAddSession: Codable {
    let spot: String
    let sessionDatetime: Date
    let sessionLength: Double
    let wordOne: String
    let wordTwo: String
    let wordThree: String
    let overallScore: Double
    let waveCount: Int?
    let goodWaveCount: Int?
    let crowd: String?
    let lineup: String?
    let waveHeight: String?
    let timeBeteenWaves: String?
    let extraNotes: String?
    let user: User
}
