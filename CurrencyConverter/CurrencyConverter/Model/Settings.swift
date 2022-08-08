//
//  Settings.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation

struct Settings: Codable {
    var commissionFee: Double
    var minFreeConversion: Double
    var availFreeConversions: Int
}
