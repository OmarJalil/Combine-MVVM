//
//  QuoteViewModel.swift
//  Combie-MVVM
//
//  Created by Jalil Fierro on 10/12/22.
//

import Combine
import Foundation

final class QuoteViewModel {

    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }

    enum Output {
        case fetchQuoteDidFail(error: Error)
        case fetchQuoteDidSucceed(quote: Quote)
        case toggleButton(isEnabled: Bool)
    }

    private let quoteService: QuoteServiceType
    // Does not contain an initial value
    // While CurrentValueSubject would contain an initial value CurrentValueSubject<Output, Never> = .init(.toggleButton(isEnabled: true))
    private let output: PassthroughSubject<Output, Never> = .init()
    private lazy var observers = Set<AnyCancellable>()

    init(quoteService: QuoteServiceType = QuoteService()) {
        self.quoteService = quoteService
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {

        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .refreshButtonDidTap:
                self?.getRandomQuote()
            }
        }.store(in: &observers)

        return output.eraseToAnyPublisher()
    }
}

private extension QuoteViewModel {

    func getRandomQuote() {
        output.send(.toggleButton(isEnabled: false))

        quoteService.getRandomQuote().sink { [weak self] completion in
            self?.output.send(.toggleButton(isEnabled: true))
            if case .failure(let error) = completion {
                self?.output.send(.fetchQuoteDidFail(error: error))
            }
        } receiveValue: { [weak self] quote in
            self?.output.send(.fetchQuoteDidSucceed(quote: quote))
        }.store(in: &observers)
    }
}
