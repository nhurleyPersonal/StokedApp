//
//  FilterModel.swift
//  Stoked
//
//  Created by Noah Hurley on 4/15/24.
//

import Foundation


struct FilterCriteria {
    var spotName: String?
    var dateRange: ClosedRange<Date>?
    var minWaveHeight: Double?
    var minOverallScore: Double?
}
