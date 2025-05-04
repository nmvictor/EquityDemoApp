//
//  FavoriteCoinsRepository.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//

import Foundation

protocol FavoriteCoinsRepository {
    func all() async throws -> [Coin]
    func add(_ coin: Coin) async throws
    func delete(for id: String) async throws
    func find(id: String) async throws -> Coin?
    func isFavorite(_ coin: Coin) async throws -> Bool
}

struct UserDefaultsFavoriteCoinsRepository: FavoriteCoinsRepository {

    
    var userDefaults: UserDefaults = .standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func all() async throws -> [Coin] {
        let coins = try fetch()
        return coins
    }
    
    func add(_ coin: Coin) async throws {
        var coins = try fetch()
        coins.append(coin)
        try store(coins: coins)
    }
    
    func delete(for id: String) async throws {
        var coins = try fetch()
        coins.removeAll(where: { $0.uuid == id })
        try store(coins: coins)
    }
    
    func find(id: String) async throws -> Coin? {
        try fetch().first(where: { $0.uuid == id })
    }
    
    func isFavorite(_ coin: Coin) async throws -> Bool {
        try await find(id: coin.uuid) != nil
    }

    private func fetch() throws -> [Coin] {
        guard let coinsData = userDefaults.object(forKey: "coins") as? Data else {
            return []
        }
        return try decoder.decode([Coin].self, from: coinsData)
    }
    
    private func store(coins: [Coin]) throws {
        let coinsData = try encoder.encode(coins)
        userDefaults.set(coinsData, forKey: "coins")
    }
}
