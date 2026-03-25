

import Foundation
protocol CreatePaymentUseCase: AnyObject {
    func execute(payment: Payment) throws
}

class CreatePaymentUseCaseImp: CreatePaymentUseCase {
    
    private let repository: CreatePaymentRepository 
    init(repository: CreatePaymentRepository) {
        self.repository = repository
    }
    
    func execute(payment: Payment ) throws { 
         
        try repository.createPayment(payment: payment)
    }
}
