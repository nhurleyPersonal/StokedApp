//
//  Board.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import Foundation

struct Board: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var userId: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case userId
    }
}
