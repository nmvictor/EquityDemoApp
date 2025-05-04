//
//  CoinrankingRepository.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


struct ApiResponse<T: Decodable>: Decodable {
    let status: String?
    let data: T
}

struct Coin: Decodable, Encodable {
    let uuid, symbol, name, color, iconUrl, marketCap, price, change, _24hVolume: String
    let rank, tier: Int
    let sparkline: [String]
    let listedAt: Double
    private enum CodingKeys : String, CodingKey {
        case  uuid, symbol, name, color, iconUrl, marketCap, price, change, _24hVolume = "24hVolume"
        case rank, tier
        case sparkline
        case listedAt
        }
}

struct CoinsData: Decodable {
    let stats: Stats
    let coins: [Coin]
    
}

struct Stats: Decodable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalMarketCap, total24hVolume: String
}

protocol CoinrankingRepository {
    /// Fetch Coins
    func fetch(_ completion: @escaping(Result<CoinsData, Error>) -> Void) async
    
    /// Returns a Coin for the given ID if it exists.
    func find(id: String, _ completion: @escaping (Result<Coin,Error>) -> Void ) async
}
