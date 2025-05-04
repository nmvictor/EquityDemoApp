//
//  HomeViewModel.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import Foundation

// MARK: - Delegates

protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func viewModelCoinDidTap(_ coin: Coin, _ viewModel: CoinsViewModel)
    func viewModelFavoritesDidTap(_ viewModel: CoinsViewModel)
    func viewModelAllDidTap(_ viewModel: CoinsViewModel)
}

protocol HomeViewModelViewDelegate: AnyObject {
    func viewModelTitlesDidUpdate(_ viewModel: CoinsViewModel)
    func viewModelStartLoading(_ viewModel: CoinsViewModel)
    func viewModelStopLoading(_ viewModel: CoinsViewModel)
}

// MARK: - Protocol

protocol CoinsViewModel {
    
    var viewDelegate: HomeViewModelViewDelegate? { get set }
    
    func getCoins(_ completion: @escaping (Result<CoinsData, Error>) -> Void) async
    func getFavoriteCoins(showLoader: Bool, _ completion: @escaping (Result<[Coin], Error>) -> Void) async
    func isFavorite(_ coin: Coin, _ completion: @escaping (Result<Bool, Error>) -> Void) async
    func favoriteTap(_ coin: Coin, _ completion: @escaping (Result<Void, Error>) -> Void) async
    func unfavoriteTap(_ coin: Coin, _ completion: @escaping (Result<Void, Error>) -> Void) async
    func coinTapped(_ coin: Coin)
    func showFavoritesTapped()
    func showAllTapped()
}

// MARK: - Implementation

final class CoinsViewModelImplementation: CoinsViewModel {
    
    var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    var viewDelegate: HomeViewModelViewDelegate?
    
    private var repository: CoinrankingRepository
    private var favoriteRepository: FavoriteCoinsRepository
    
    init(repository: CoinrankingRepository, favoriteRepository: FavoriteCoinsRepository) {
        self.repository = repository
        self.favoriteRepository = favoriteRepository
    }
    
    func getFavoriteCoins(showLoader: Bool = false, _ completion: @escaping (Result<[Coin], any Error>) -> Void) async {
        do {
            if showLoader {
                viewDelegate?.viewModelStartLoading(self)
            }
            let coins = try await favoriteRepository.all()
            completion(Result.success((coins)))
            if showLoader {
                self.viewDelegate?.viewModelStopLoading(self)
            }
        } catch let error {
            completion(Result.failure(error))
            if showLoader {
                self.viewDelegate?.viewModelStopLoading(self)
            }
        }
    }

    func getCoins(_ completion: @escaping (Result<CoinsData, Error>) -> Void) async {
        viewDelegate?.viewModelStartLoading(self)
        await self.repository.fetch { [weak self] result in
            guard let self = self else { return }
            debugPrint(result)
            completion(result)
            self.viewDelegate?.viewModelStopLoading(self)
        }
    }
    
    func isFavorite(_ coin: Coin, _ completion: @escaping (Result<Bool, Error>) -> Void) async {
        do {
            let isFav = try await favoriteRepository.isFavorite(coin)
            completion(Result.success((isFav)))
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    func favoriteTap(_ coin: Coin, _ completion: @escaping (Result<Void, Error>) -> Void) async {
        do {
            try await favoriteRepository.add(coin)
            completion(Result.success(()))
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    func unfavoriteTap(_ coin: Coin, _ completion: @escaping (Result<Void, Error>) -> Void) async {
        do {
            try await favoriteRepository.delete(for: coin.uuid)
            completion(Result.success(()))
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    func coinTapped(_ coin: Coin) {
        coordinatorDelegate?.viewModelCoinDidTap(coin, self)
    }
    
    func showFavoritesTapped() {
        coordinatorDelegate?.viewModelFavoritesDidTap(self)
    }
    
    func showAllTapped() {
        coordinatorDelegate?.viewModelAllDidTap(self)
    }
}

// MARK: - DependencyDelegate

extension CoinsViewModelImplementation: DependencyDelegate {
    func appDependencyDidUpdate() {
        viewDelegate?.viewModelTitlesDidUpdate(self)
    }
}
