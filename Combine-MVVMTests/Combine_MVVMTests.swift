//
//  Combine_MVVMTests.swift
//  Combine-MVVMTests
//
//  Created by Jalil Fierro on 10/12/22.
//

import XCTest
import Combine
@testable import Combie_MVVM

final class Combine_MVVMTests: XCTestCase {

    var sut: QuoteViewModel!
    var quoteService: MockQuoteService!
    var input: PassthroughSubject<QuoteViewModel.Input, Never>!
    var observers: Set<AnyCancellable>!

    override func setUpWithError() throws {
        quoteService = MockQuoteService()
        sut = QuoteViewModel(quoteService: quoteService)
        input = .init()
        observers = []
    }


    func testMockShouldBringDataOnRefreshButtonDidTap() throws {
        let dataExpectation = XCTestExpectation(description: "Should wait for fetchQuoteDidSucceed")

        let buttonExpectation = XCTestExpectation(description: "Should change isEnabled twice")
        buttonExpectation.expectedFulfillmentCount = 2

        let output = sut.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { event in
                switch event {
                case .fetchQuoteDidFail(let error):
                    XCTFail(error.localizedDescription)

                case .fetchQuoteDidSucceed(let quote):
                    XCTAssertEqual("My quote", quote.content)
                    XCTAssertEqual("Jalil", quote.author)
                    dataExpectation.fulfill()

                case .toggleButton(let isEnabled):
                    buttonExpectation.fulfill()
                }
            }.store(in: &observers)

        input.send(.refreshButtonDidTap)
        wait(for: [dataExpectation, buttonExpectation], timeout: 5.0)
    }

}
