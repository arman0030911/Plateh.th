import Foundation

protocol DeletePaymentUseCase: AnyObject {
    func execute(id: String) throws
}

class DeletePaymentUseCaseImpl: DeletePaymentUseCase {
    private let repository: DeletePaymentRepository

    init(repository: DeletePaymentRepository) {
        self.repository = repository
    }

    func execute(id: String) throws {
        try repository.deletePayment(id: id)
    }
}
