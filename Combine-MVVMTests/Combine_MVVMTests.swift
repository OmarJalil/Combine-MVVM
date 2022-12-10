//
//  Combine_MVVMTests.swift
//  Combine-MVVMTests
//
//  Created by Jalil Fierro on 10/12/22.
//

import XCTest
@testable import Combie_MVVM

final class Combine_MVVMTests: XCTestCase {

    var sut: QuoteViewModel!
    var quoteService: MockQuoteService!

    override func setUpWithError() throws {
        quoteService = MockQuoteService()
        sut = QuoteViewModel(quoteService: quoteService)
    }

}
