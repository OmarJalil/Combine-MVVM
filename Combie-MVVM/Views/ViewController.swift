//
//  ViewController.swift
//  Combie-MVVM
//
//  Created by Jalil Fierro on 09/12/22.
//

import Combine
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!

    private lazy var viewModel = QuoteViewModel()
    private lazy var input: PassthroughSubject<QuoteViewModel.Input, Never> = .init()
    private lazy var observers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }

    @IBAction func refreshButtonTapped() {
        input.send(.refreshButtonDidTap)
    }

}

private extension ViewController {

    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
        .receive(on: DispatchQueue.main)
        .sink { [weak self] event in
            switch event {
            case .fetchQuoteDidFail(let error):
                self?.quoteLabel.text = error.localizedDescription

            case .fetchQuoteDidSucceed(let quote):
                self?.quoteLabel.text = quote.content

            case .toggleButton(let isEnabled):
                self?.refreshButton.isEnabled = isEnabled
            }
        }
        .store(in: &observers)
    }
}
