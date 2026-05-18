import Foundation

protocol SetPaymentUseCase: AnyObject { 
    func execute(payment: Payment) throws 
    
}

class SetPaymentUseCaseImpl: SetPaymentUseCase { 
    private let repository: SetPaymentRepository 
    init(repository: SetPaymentRepository) {
        self.repository = repository
    } 
// писать через свич 
    func execute(payment: Payment) throws { 
        try repository.setPayment(payment: payment)
    }
}


