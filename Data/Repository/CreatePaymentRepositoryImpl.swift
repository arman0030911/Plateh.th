import Foundation

class CreatePaymentRepositoryImpl: CreatePaymentRepository{ 
    private let dataSource: CreatePaymentDataSource 
    init(dataSource: CreatePaymentDataSource) {
        self.dataSource = dataSource
    }
    func createPayment(payment: Payment) throws {
        try dataSource.createNewPayment(payment: payment)
    }
}
