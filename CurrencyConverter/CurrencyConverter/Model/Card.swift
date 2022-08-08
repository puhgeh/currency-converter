//
//  Card.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    let id = UUID().uuidString
    let currency: String
    var balance: Decimal
    let color: Color
    var offset: CGFloat = 0
    let number: String
}
