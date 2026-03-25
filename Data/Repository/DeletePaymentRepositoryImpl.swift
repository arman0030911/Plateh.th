import Foundation

class DeletePaymentRepositoryImpl: DeletePaymentRepository {
    private let dataSource: DeletePaymentDataSource

    init(dataSource: DeletePaymentDataSource) {
        self.dataSource = dataSource
    }

    func deletePayment(id: String) throws {
        try dataSource.deletePayment(id: id)
    }
}
