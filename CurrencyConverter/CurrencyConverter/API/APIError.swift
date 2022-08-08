//
//  APIError.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown(reason: String), apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown(let reason):
            return reason
        case .apiError(let reason):
            return reason
        }
    }
}
