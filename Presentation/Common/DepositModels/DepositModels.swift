import Foundation

struct Bank: Codable {
    let id: UUID
    let name: String
    let logoUrl: String?
    let website: String?
    let isActive: Bool
}

struct DepositRate: Codable, Identifiable {
    let id: UUID
    let bank: Bank
    let currency: String
    let termDays: Int
    let interestRate: Double
    let minAmount: Double?
    let updatedAt: Date?
}

enum DepositCurrencyOption: String, CaseIterable, Identifiable {
    case turkishLira = "TRY"
    case usd = "USD"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .turkishLira:
            return "₺"
        case .usd:
            return "$"
        }
    }
}

struct DepositTermOption: Hashable, Identifiable {
    let months: Int
    let days: Int

    var id: Int { days }

    var title: String {
        "\(months) ay"
    }

    var shortTitle: String {
        "\(days) gün"
    }

    static let all: [DepositTermOption] = [
        DepositTermOption(months: 1, days: 32),
        DepositTermOption(months: 3, days: 90),
        DepositTermOption(months: 6, days: 180)
    ]

    static let initial = DepositTermOption.all[0]

    static func option(for days: Int) -> DepositTermOption {
        all.first(where: { $0.days == days }) ?? initial
    }
}

extension DepositRate {
    var currencyOption: DepositCurrencyOption {
        DepositCurrencyOption(rawValue: currency.uppercased()) ?? .turkishLira
    }
}
