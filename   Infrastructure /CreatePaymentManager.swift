import Foundation
import CoreData

class CreatePaymentManager: CreatePaymentDataSource {
    private let context: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext

    // MARK: - Public API

    func createNewPayment(payment: Payment) throws {
        var thrownError: Error?
        var savedPayment: Payment?

        context.performAndWait {
            let entity = PaymentMapper.toEntity(from: payment, context: context)
            do {
                try context.save()
                savedPayment = PaymentMapper.toDomain(from: entity)
            } catch {
                thrownError = error
            }
        }

        if let thrownError {
            throw thrownError
        }

        if let savedPayment {
            NotificationManager.shared.scheduleNotification(for: savedPayment)
        }
    }
}
