//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation
import Combine

class CurrencyService {
    static let shared = CurrencyService()
    private var cancellables: Set<AnyCancellable> = []
    
    func convert(_ money: Money, toCurrency: String) throws -> AnyPublisher<Response<Money>, Error> {
        do {
            let request = try Route.convert(amount: Decimal(string: money.amount) ?? 0.0, fromCurrency: money.currency, toCurrency: toCurrency).request()
            return (APIClient.run(request) as AnyPublisher<Response<Money>, Error>)
        } catch {
            throw APIError.apiError(reason: error.localizedDescription)
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
