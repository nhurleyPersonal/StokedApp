//
//  Spot.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import Foundation

struct Spot: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var buoyId: String
    var buoyX: String
    var buoyY: String
    var lat: String
    var lon: String
    var depth: String
    var slope: String
    var tideStation: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case buoyId
        case buoyX = "buoy_x"
        case buoyY = "buoy_y"
        case lat
        case lon
        case depth
        case slope
        case tideStation = "tide_station"
    }
}
