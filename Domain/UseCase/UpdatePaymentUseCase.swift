import Foundation

protocol UpdatePaymentUseCase: AnyObject {
    func updateNotification(id: String, isEnabled: Bool) throws
    func closePayment(id: String) throws
    func deleteLastPayment(id: String) throws
}

class UpdatePaymentUseCaseImpl: UpdatePaymentUseCase {
    private let repository: UpdatePaymentRepository

    init(repository: UpdatePaymentRepository) {
        self.repository = repository
    }

    func updateNotification(id: String, isEnabled: Bool) throws {
        try repository.updateNotification(id: id, isEnabled: isEnabled)
    }

    func closePayment(id: String) throws {
        try repository.closePayment(id: id)
    }

    func deleteLastPayment(id: String) throws {
        try repository.deleteLastPayment(id: id)
    }
}
