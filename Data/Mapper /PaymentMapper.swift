//
//  PaymentMapper.swift
//  Plateh.th
//
//  Created by Adis on 14.03.2026.
//



import Foundation
import CoreData

struct PaymentMapper {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static func toDomain(from enitie: PaymentEntitly) -> Payment {
        let id = enitie.id ?? UUID().uuidString
        let type = PayType(rawValue: Int(enitie.type)) ?? .monthly
        let title = enitie.title ?? ""
        let descriptionText = enitie.descriptionText ?? ""
        let paymentAmount = enitie.paymentAmount?.doubleValue ?? 0
        let totalAmount = enitie.totalAmount?.doubleValue ?? 0
        let remainingAmount = enitie.remainingAmount?.doubleValue
        let dueDay = Int(enitie.dueDay)
   
        let dueDateString: String? = {
             if let date = enitie.dueDate {
                return dateFormatter.string(from: date)
            }
            return nil
        }()
        
        let createdAtString: String = {
            if let createdAt = enitie.createdAt {
                return dateFormatter.string(from: createdAt)
            } else {
                return dateFormatter.string(from: Date())
            }
        }()
        
        let lastPayString: String? = {
            if let lastPay = enitie.lastPay {
                return dateFormatter.string(from: lastPay)
            }
            return nil
        }()

        let closeDateString: String? = {
            if let closeDate = enitie.closeDate {
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
            dueDate: dueDateString,  // Date → String
            isNotificationEnabled: enitie.isNotificationEnables,
            createdAt: createdAtString, // Date → String
            lastPay: lastPayString,     // Date → String
            storedRemainingAmount: remainingAmount,
            isClosedStored: enitie.isClosed,
            closeDate: closeDateString
        )

        return payment
    }

    static func toEntitie(from: Payment, context: NSManagedObjectContext) -> PaymentEntitly {
        let entitie = PaymentEntitly(context: context)
        // Fill when persisting:
        entitie.id = from.id.isEmpty ? UUID().uuidString : from.id
        entitie.type = Int16(from.type.rawValue)
        entitie.title = from.title
        entitie.descriptionText = from.description
        entitie.paymentAmount = NSDecimalNumber(value: from.paymentAmount)
        entitie.totalAmount = NSDecimalNumber(value: from.totalAmount)
        entitie.remainingAmount = NSDecimalNumber(value: from.storedRemainingAmount ?? from.totalAmount)
        entitie.dueDay = Int16(from.dueDay ?? 0)
        
        // String → Date: если строка не парсится, оставим nil/дефолт
        if let dueDateStr = from.dueDate, let date = dateFormatter.date(from: dueDateStr) {
            entitie.dueDate = date
        } else {
            entitie.dueDate = nil
        }
        
        entitie.isNotificationEnables = from.isNotificationEnabled
        
        if let createdAtDate = dateFormatter.date(from: from.createdAt) {
            entitie.createdAt = createdAtDate
        } else {
            entitie.createdAt = Date()
        }
        
        if let lastPayStr = from.lastPay, let date = dateFormatter.date(from: lastPayStr) {
            entitie.lastPay = date
        } else {
            entitie.lastPay = nil
        }
        entitie.isClosed = from.isClosedStored

        if let closeDateStr = from.closeDate, let date = dateFormatter.date(from: closeDateStr) {
            entitie.closeDate = date
        } else {
            entitie.closeDate = nil
        }
        return entitie
    }
}
