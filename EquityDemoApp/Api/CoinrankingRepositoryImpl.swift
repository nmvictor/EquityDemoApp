//
//  CoinrankingRepositoryImpl.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//

import Foundation


struct CoinrankingRepositoryImpl: CoinrankingRepository {
    let apiKey = "coinranking76cf9f6194bbf89fa8a126b992edba6514e1579944d4fd19"
    
    func fetch(_ completion: @escaping (Result<CoinsData, any Error>) -> Void) async {
        let url = URL(string: "https://api.coinranking.com/v2/coins")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")

        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            if let error = error { completion(.failure(error)); return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            completion(Result { try decoder.decode(ApiResponse<CoinsData>.self, from: data!).data })
        }
        task.resume()
    }
    
    func find(id: String, _ completion: @escaping (Result<Coin, any Error>) -> Void) async {
        
    }
    
}
  
