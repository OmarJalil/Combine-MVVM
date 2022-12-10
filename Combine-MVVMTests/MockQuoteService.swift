//
//  MockQuoteService.swift
//  Combine-MVVMTests
//
//  Created by Jalil Fierro on 10/12/22.
//

import Combine
import Foundation
@testable import Combie_MVVM

class MockQuoteService: QuoteServiceType {

    var value: AnyPublisher<Quote, Error>?
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        return Just(Quote(content: "My quote", author: "Jalil"))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
