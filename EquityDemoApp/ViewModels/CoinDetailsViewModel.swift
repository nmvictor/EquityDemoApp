//
//  CoinDetailsViewModel.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import Foundation

// MARK: - Delegates

protocol CoinDetailsViewModelCoordinatorDelegate: AnyObject {
    func viewModelDidFinish(_ viewModel: CoinDetailsViewModel)
}

protocol CoinDetailsViewModelViewDelegate: AnyObject {
    func viewModelStartLoading(_ viewModel: CoinDetailsViewModel)
    func viewModelStopLoading(_ viewModel: CoinDetailsViewModel)
}

// MARK: - Implementation

final class CoinDetailsViewModel: ObservableObject {
    
    weak var coordinatorDelegate: CoinDetailsViewModelCoordinatorDelegate?
    weak var viewDelegate: CoinDetailsViewModelViewDelegate?
    
    let errorAlertTitle: String = "Something Went Wrong"
    let errorAlertButtonTitle: String = "OK"
    let buttonTitle: String = "Close"
    
    @Published var title: String = ""
    @Published var symbol: String = ""
    @Published var price: String = ""
    @Published var marketCap: String = ""
    @Published var tier: String = ""
    @Published var rank: String = ""
    @Published var isLoading: Bool = false {
        didSet {
            if isLoading {
                viewDelegate?.viewModelStartLoading(self)
            } else {
                viewDelegate?.viewModelStopLoading(self)
            }
        }
    }
    @Published var shouldShowAlert: Bool = false
    @Published var coin: Coin {
        didSet(old) {
            // didSet called twice
            guard coin.uuid != old.uuid else { return }
            dependency.coin = coin
            prepareUI()
        }
    }
    
    private var dependency: Dependency
    
    init(dependency: Dependency, coin: Coin) {
        self.coin = coin
        self.dependency = dependency
        prepareUI()
        load()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    private func prepareUI() {
        if let coin = dependency.coin,
           !coin.name.isEmpty {
            title = "\(coin.name) Coin"
            price = "\(coin.price)"
            symbol = "\(coin.symbol)"
            tier = "\(coin.tier)"
            rank = "\(coin.rank)"
            marketCap = "\(coin.marketCap)"
        } else {
            title = "Coin Details!"
        }
    }
    
    func load() {
        self.isLoading = true
        dependency.updated()
        self.isLoading = false
    }
    
    func buttonTapped() {
        DispatchQueue.main.async {
            self.coordinatorDelegate?.viewModelDidFinish(self)
        }
        
    }
    
    func errorAlertButtonTapped() {
        shouldShowAlert = false
    }
}
