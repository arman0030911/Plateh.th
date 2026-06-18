import Foundation

public struct BankCard: Identifiable, Equatable, Codable {
    public let id: String
    public var holderName: String
    public var last4: String
    public var expiryMonth: Int
    public var expiryYear: Int

    public init(id: String = UUID().uuidString, holderName: String, last4: String, expiryMonth: Int, expiryYear: Int) {
        self.id = id
        self.holderName = holderName
        self.last4 = last4
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
}
