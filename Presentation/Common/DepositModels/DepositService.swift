import Foundation

actor DepositService {
    static let shared = DepositService()
    private let baseURL = AppConfig.depositAPIBaseURL

    // MARK: - Networking

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
