import Foundation

class UpdatePaymentRepositoryImpl: UpdatePaymentRepository {
    private let dataSource: UpdatePaymentDataSource

    init(dataSource: UpdatePaymentDataSource) {
        self.dataSource = dataSource
    }

    func updateNotification(id: String, isEnabled: Bool) throws {
        try dataSource.updateNotification(id: id, isEnabled: isEnabled)
    }

    func closePayment(id: String) throws {
        try dataSource.closePayment(id: id)
    }

    func deleteLastPayment(id: String) throws {
        try dataSource.deleteLastPayment(id: id)
    }
}
