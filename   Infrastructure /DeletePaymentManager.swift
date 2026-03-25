import Foundation
import CoreData

class DeletePaymentManager: DeletePaymentDataSource {
    private let context = PersistentContainer.shared.persistentContainer.viewContext

    func deletePayment(id: String) throws {
        var thrownError: Error?

        context.performAndWait {
            let request = PaymentEntitly.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)

            do {
                let result = try context.fetch(request)
                guard let payment = result.first else { return }
                if let id = payment.id {
                    NotificationManager.shared.removeNotification(id: id)
                }
                context.delete(payment)

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                thrownError = error
            }
        }

        if let thrownError {
            throw thrownError
        }
    }
}
