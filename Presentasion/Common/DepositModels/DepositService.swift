//
//  DepositService.swift
//  Plateh.th
//
//  Created by Adis on 13.04.2026.
//

import Foundation

actor DepositService {
    // Для симулятора (сервер на том же Mac)
    private let baseURL = "http://localhost:8080/api"
    
    // Для реального устройства – замени IP на адрес твоего Mac в локальной сети
    // private let baseURL = "http://192.168.1.42:8080/api"
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetchRates(currency: String, term: Int) async throws -> [DepositRate] {
        var components = URLComponents(string: "\(baseURL)/rates")
        components?.queryItems = [
            URLQueryItem(name: "currency", value: currency),
            URLQueryItem(name: "term", value: String(term))
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode([DepositRate].self, from: data)
    }
}
