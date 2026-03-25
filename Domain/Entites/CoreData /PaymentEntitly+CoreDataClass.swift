//
//  PaymentEntitly+CoreDataClass.swift
//  Plateh.th
//
//  Created by Adis on 14.03.2026.
//
//

import Foundation
import CoreData

public typealias PaymentEntitlyCoreDataClassSet = NSSet

@objc(PaymentEntitly)
public class PaymentEntitly: NSManagedObject {

}

public typealias PaymentEntitlyCoreDataPropertiesSet = NSSet

extension PaymentEntitly {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentEntitly> {
        return NSFetchRequest<PaymentEntitly>(entityName: "PaymentEntitly")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: Int16
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var paymentAmount: NSDecimalNumber?
    @NSManaged public var totalAmount: NSDecimalNumber?
    @NSManaged public var dueDay: Int16
    @NSManaged public var dueDate: Date?
    @NSManaged public var isNotificationEnables: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var lastPay: Date?
    @NSManaged public var remainingAmount: NSDecimalNumber?
    @NSManaged public var isClosed: Bool
    @NSManaged public var closeDate: Date?

}

extension PaymentEntitly: Identifiable {

}
