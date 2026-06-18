import Foundation

protocol BankCardRepository {
    func save(card: BankCard, cvv: String) async throws
    func fetchAll() async throws -> [BankCard]
}

final class UserDefaultsBankCardRepository: BankCardRepository {
    private let key = "bankcards"

    func save(card: BankCard, cvv: String) async throws {
        // Save CVV to Keychain
        let cvvKey = "card_cvv_\(card.id)"
        if let data = cvv.data(using: .utf8) {
            _ = KeychainHelper.save(key: cvvKey, data: data)
        }

        // Save metadata to UserDefaults
        var current = try await fetchAll()
        current.append(card)
        let encoder = JSONEncoder()
        let data = try encoder.encode(current)
        UserDefaults.standard.set(data, forKey: key)
    }

    func fetchAll() async throws -> [BankCard] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return try decoder.decode([BankCard].self, from: data)
    }
}
