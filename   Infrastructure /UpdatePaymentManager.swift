import Foundation
import CoreData

class UpdatePaymentManager: UpdatePaymentDataSource {
    private let context = PersistentContainer.shared.persistentContainer.viewContext

    func updateNotification(id: String, isEnabled: Bool) throws {
        try update(id: id) { payment in
            payment.isNotificationEnables = isEnabled
        }
    }

    func closePayment(id: String) throws {
        try update(id: id) { payment in
            payment.lastPay = .now
            payment.remainingAmount = .zero
            payment.isClosed = true
            payment.closeDate = .now
            payment.isNotificationEnables = false
        }
    }

    func deleteLastPayment(id: String) throws {
        try update(id: id) { payment in
            let total = payment.totalAmount?.decimalValue ?? .zero
            let current = payment.remainingAmount?.decimalValue ?? total
            let paymentAmount = payment.paymentAmount?.decimalValue ?? .zero

            payment.isClosed = false
            payment.closeDate = nil

            if payment.type == 0 {
                if let lastPay = payment.lastPay {
                    payment.lastPay = lastPay.previousMonth
                }

                let restored = min(total, current + paymentAmount)
                payment.remainingAmount = NSDecimalNumber(decimal: restored)
                payment.isNotificationEnables = true
            } else {
                payment.lastPay = nil
                payment.remainingAmount = payment.totalAmount
                payment.isNotificationEnables = true
            }
        }
    }

    private func update(id: String, change: @escaping (PaymentEntitly) -> Void) throws {
        var thrownError: Error?

        context.performAndWait {
            let request = PaymentEntitly.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)

            do {
                let result = try context.fetch(request)
                guard let payment = result.first else { return }
                change(payment)

                if context.hasChanges {
                    try context.save()
                    let updatedPayment = PaymentMapper.toDomain(from: payment)
                    if updatedPayment.isNotificationEnabled, !updatedPayment.isClosed {
                        NotificationManager.shared.scheduleNotification(for: updatedPayment)
                    } else {
                        NotificationManager.shared.removeNotification(id: updatedPayment.id)
                    }
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
