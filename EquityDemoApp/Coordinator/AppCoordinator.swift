//
//  AppCoordinator.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import UIKit

final class AppCoordinator: Coordinator {
    
    private(set) var navigationController: UINavigationController
    private lazy var dependency: Dependency = AppDependency()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CoinsViewModelImplementation( repository: CoinrankingRepositoryImpl(), favoriteRepository: UserDefaultsFavoriteCoinsRepository())
        viewModel.coordinatorDelegate = self
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showCoinDetails(coin: Coin) {
        dependency.coin = coin
        let viewModel = CoinDetailsViewModel(dependency: dependency, coin: coin)
        viewModel.coordinatorDelegate = self
        let rootView: CoinDetailsView = CoinDetailsView(viewModel: viewModel)
        let viewController = CoinDetailsViewController(rootView: rootView)
        navigationController.pushViewController(viewController, animated: true)
        // show swiftui view
    }
    
    func showFavoriteCoins() {
        let viewModel = CoinsViewModelImplementation( repository: CoinrankingRepositoryImpl(), favoriteRepository: UserDefaultsFavoriteCoinsRepository())
        viewModel.coordinatorDelegate = self
        let viewController = FavoriteCoinsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - HomeViewModelCoordinatorDelegate

extension AppCoordinator: HomeViewModelCoordinatorDelegate {
    func viewModelCoinDidTap(_ coin: Coin, _ viewModel: any CoinsViewModel) {
        showCoinDetails(coin: coin)
    }
    
    func viewModelFavoritesDidTap(_ viewModel: any CoinsViewModel) {
       showFavoriteCoins()
    }
    
    func viewModelAllDidTap(_ viewModel: any CoinsViewModel) {
        navigationController.popViewController(animated: true)
    }
    
}

// MARK: - HomeViewModelCoordinatorDelegate

extension AppCoordinator: CoinDetailsViewModelCoordinatorDelegate {
    func viewModelDidFinish(_ viewModel: CoinDetailsViewModel) {
        navigationController.popViewController(animated: true)
    }
}
