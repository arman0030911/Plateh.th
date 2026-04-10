

import Foundation
import CoreData 


class SetPaymentManager: SetPaymentDataSource { 
    let context = PersistentContainer.shared.persistentContainer.viewContext

    private let calendar = Calendar.current

    private func markClosed(_ payment: PaymentEntitly) {
        payment.remainingAmount = .zero
        payment.isClosed = true
        payment.closeDate = .now
        payment.isNotificationEnables = false
    }
    
    func setPayment(payment: Payment) throws {
        var thrownError: Error?
        var updatedPayment: Payment?

        context.performAndWait {
            let request = PaymentEntitly.fetchRequest() 
            request.predicate = NSPredicate(format: "id == %@", payment.id)

            do {
                let fetched = try context.fetch(request)
                guard let contextPayment = fetched.first else { return }

                if contextPayment.isClosed {
                    return
                }

                if contextPayment.type == PayType.monthly.rawValue,
                   let lastPay = contextPayment.lastPay,
                   calendar.isDate(lastPay, equalTo: .now, toGranularity: .month) {
                    return
                }

                if contextPayment.type != PayType.monthly.rawValue, contextPayment.lastPay != nil {
                    return
                }

                contextPayment.lastPay = .now

                if contextPayment.type == PayType.monthly.rawValue {
                    contextPayment.remainingAmount = contextPayment.totalAmount
                    contextPayment.isClosed = false
                    contextPayment.closeDate = nil
                } else {
                    markClosed(contextPayment)
                }

                try context.save()
                updatedPayment = PaymentMapper.toDomain(from: contextPayment)
            } catch {
                thrownError = error
            }
        }

        if let thrownError {
            throw thrownError
        }

        if let updatedPayment {
            if updatedPayment.isClosed {
                NotificationManager.shared.removeNotification(id: updatedPayment.id)
            } else {
                NotificationManager.shared.scheduleNotification(for: updatedPayment)
            }
        }
    }
}
