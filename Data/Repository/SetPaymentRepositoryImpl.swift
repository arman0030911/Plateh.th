import Foundation

class SetPaymentRepositoryImpl: SetPaymentRepository {
    private let dataSource: SetPaymentDataSource 
    init (dataSource: SetPaymentDataSource) { 
        self.dataSource = dataSource 
        
    }
    
    func setPayment(payment: Payment) throws {
        try dataSource.setPayment(payment: payment )
    }
    
 
    
}
