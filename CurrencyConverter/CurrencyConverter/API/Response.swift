//
//  Response.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation

struct Response<T> {
    let value: T
    let response: URLResponse
    let rawData: Data?
    
    init(value: T, response: URLResponse, rawData: Data? = nil) {
        self.value = value
        self.response = response
        self.rawData = rawData
    }
}
