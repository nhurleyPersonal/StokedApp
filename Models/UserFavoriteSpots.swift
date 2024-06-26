//
//  UserFavoriteSpots.swift
//  Stoked
//
//  Created by Noah Hurley on 6/23/24.
//

import Foundation

struct UserFavoriteSpots: Codable, Identifiable {
    var id: String
    var userId: String
    var spotIds: [String]
}
