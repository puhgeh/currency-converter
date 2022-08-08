//
//  Route.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case put
    case delete
    
    func toString() -> String {
        return String(describing: self).uppercased()
    }
}

enum Route {
    case convert(amount: Decimal, fromCurrency: String, toCurrency: String)
    case currencies // for future endpoint where available currencies can be fetched
    
    var baseUrl: URL? {
        URL(string: "http://api.evp.lt/currency/commercial/exchange/")
    }
    
    var path: (string: String, method: HTTPMethod) {
        switch self {
        case .convert(let ammount, let fromCurrency, let toCurrency):
            return ("\(ammount)-\(fromCurrency)/\(toCurrency)/latest", .get)
        default:
            return ("", .post)
        }
    }
    
    func request(body: Data? = nil) throws -> URLRequest {
        guard let baseUrl = baseUrl,
              let components = URLComponents(url: baseUrl.appendingPathComponent(self.path.string), resolvingAgainstBaseURL: true),
              let url = components.url else {
            throw APIError.apiError(reason: "Unable to construct URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.path.method.toString()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
