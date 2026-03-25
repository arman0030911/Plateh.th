//
//   CraatePaymentManager.swift
//  Plateh.th
//
//  Created by Adis on 14.03.2026.
//

import Foundation
import CoreData

class CreatePaymentManager: CreatePaymentDataSource {
    private let context: NSManagedObjectContext = PersistentContainer.shared.persistentContainer.viewContext

    func createNewPayment(payment: Payment) throws {
        var thrownError: Error?
        var savedPayment: Payment?

        context.performAndWait {
            // Создаем и заполняем сущность Core Data
            let entity = PaymentMapper.toEntitie(from: payment, context: context)
            // Сохраняем контекст
            if context.hasChanges {
                do {
                    try context.save()
                    savedPayment = PaymentMapper.toDomain(from: entity)
                } catch {
                    thrownError = error
                }
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
