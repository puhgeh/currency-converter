//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation
import Combine

struct APIClient {
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .tryMap { result -> Response in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw APIError.apiError(reason: "Unable to process HTTP response")
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    let message = String(decoding: result.data, as: UTF8.self)
                    throw APIError.apiError(reason: message)
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response, rawData: result.data)
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.unknown(reason: error.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
