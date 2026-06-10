

import Foundation
import CoreData

struct PaymentMapper {
    // MARK: - Formatter

    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    // MARK: - Mapping

    static func toDomain(from entity: PaymentEntity) -> Payment {
        let id = entity.id ?? UUID().uuidString
        let type = PayType(rawValue: Int(entity.type)) ?? .monthly
        let title = entity.title ?? ""
        let descriptionText = entity.descriptionText ?? ""
        let paymentAmount = entity.paymentAmount?.doubleValue ?? 0
        let totalAmount = entity.totalAmount?.doubleValue ?? 0
        let remainingAmount = entity.remainingAmount?.doubleValue
        let dueDay = Int(entity.dueDay)

        let dueDateString: String? = {
            if let date = entity.dueDate {
                return dateFormatter.string(from: date)
            }
            return nil
        }()

        let createdAtString: String = {
            if let createdAt = entity.createdAt {
                return dateFormatter.string(from: createdAt)
            } else {
                return dateFormatter.string(from: Date())
            }
        }()

        let lastPayString: String? = {
            if let lastPay = entity.lastPay {
                return dateFormatter.string(from: lastPay)
            }
            return nil
        }()

        let closeDateString: String? = {
            if let closeDate = entity.closeDate {
                return dateFormatter.string(from: closeDate)
            }
            return nil
        }()
        
        let payment = Payment(
            id: id,
            type: type,
            title: title,
            description: descriptionText,
            paymentAmount: paymentAmount,
            totalAmount: totalAmount,
            dueDay: dueDay,
            dueDate: dueDateString,
            isNotificationEnabled: entity.isNotificationEnabled,
            createdAt: createdAtString,
            lastPay: lastPayString,
            storedRemainingAmount: remainingAmount,
            isClosedStored: entity.isClosed,
            closeDate: closeDateString
        )

        return payment
    }

    static func toEntity(from payment: Payment, context: NSManagedObjectContext) -> PaymentEntity {
        let entity = PaymentEntity(context: context)

        entity.id = payment.id.isEmpty ? UUID().uuidString : payment.id
        entity.type = Int16(payment.type.rawValue)
        entity.title = payment.title
        entity.descriptionText = payment.description
        entity.paymentAmount = NSDecimalNumber(value: payment.paymentAmount)
        entity.totalAmount = NSDecimalNumber(value: payment.totalAmount)
        entity.remainingAmount = NSDecimalNumber(value: payment.storedRemainingAmount ?? payment.totalAmount)
        entity.dueDay = Int16(payment.dueDay ?? 0)

        if let dueDateStr = payment.dueDate, let date = dateFormatter.date(from: dueDateStr) {
            entity.dueDate = date
        } else {
            entity.dueDate = nil
        }

        entity.isNotificationEnabled = payment.isNotificationEnabled

        if let createdAtDate = dateFormatter.date(from: payment.createdAt) {
            entity.createdAt = createdAtDate
        } else {
            entity.createdAt = Date()
        }

        if let lastPayStr = payment.lastPay, let date = dateFormatter.date(from: lastPayStr) {
            entity.lastPay = date
        } else {
            entity.lastPay = nil
        }
        entity.isClosed = payment.isClosedStored

        if let closeDateStr = payment.closeDate, let date = dateFormatter.date(from: closeDateStr) {
            entity.closeDate = date
        } else {
            entity.closeDate = nil
        }
        return entity
    }

}
