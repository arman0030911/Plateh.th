import Foundation


struct Payment: Identifiable, Hashable {
    let id: String
    let type: PayType
    var title: String
    var description: String
    var paymentAmount: Double
    var totalAmount: Double
    var dueDay: Int?
    var dueDate: String?      // Было Date?, стало String?
    var isNotificationEnabled: Bool
    var createdAt: String     // Было Date, стало String
    var lastPay: String?      // Было Date?, стало String?
    var storedRemainingAmount: Double?
    var isClosedStored: Bool
    var closeDate: String?

    var lastPayDate: Date? {
        Date.fromISO8601(lastPay)
    }

    var closeDateValue: Date? {
        Date.fromISO8601(closeDate)
    }
    
    var remainingAmount: Double {
        switch type {
        case .monthly:
            return max(storedRemainingAmount ?? totalAmount, 0)
        case .oneTime:
            return lastPay == nil ? totalAmount : 0
        }
    }

    var isClosed: Bool {
        isClosedStored || remainingAmount <= 0
    }

    var isPaid: Bool {
        switch type {
        case .monthly:
            guard !isClosed else { return true }
            guard let lastPayDate else { return false }
            return Calendar.current.isDate(lastPayDate, equalTo: .now, toGranularity: .month)
        case .oneTime:
            return lastPayDate != nil || isClosed
        }
    }
    
    // Hashable только по id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        lhs.id == rhs.id
    }
}
