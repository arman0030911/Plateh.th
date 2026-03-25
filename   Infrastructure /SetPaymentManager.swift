

import Foundation
import CoreData 


class SetPaymentManager: SetPaymentDataSource { 
    let contex = PersistentContainer.shared.persistentContainer.viewContext

    private let calendar = Calendar.current

    private func markClosed(_ payment: PaymentEntitly) {
        payment.remainingAmount = .zero
        payment.isClosed = true
        payment.closeDate = .now
        payment.isNotificationEnables = false
    }
    
    func setPayment(payment: Payment) throws {
        let req = PaymentEntitly.fetchRequest() 
        req.predicate = NSPredicate(format: "id == %@", payment.id)
        
        let payment = try contex.fetch(req)
        if let contexPayment = payment.first {
            if contexPayment.isClosed {
                return
            }
            if contexPayment.type == 0, (contexPayment.remainingAmount?.decimalValue ?? .zero) <= .zero {
                return
            }
            if contexPayment.type == 0,
               let lastPay = contexPayment.lastPay,
               calendar.isDate(lastPay, equalTo: .now, toGranularity: .month) {
                return
            }
            if contexPayment.type != 0, contexPayment.lastPay != nil {
                return
            }

            contexPayment.lastPay = .now 
            
            if contexPayment.type == 0 {
                var remainingAmount = contexPayment.remainingAmount?.decimalValue
                    ?? contexPayment.totalAmount?.decimalValue
                    ?? .zero
                let paymentAmount = contexPayment.paymentAmount?.decimalValue ?? .zero
                remainingAmount -= paymentAmount
                if remainingAmount < 0 { 
                    contexPayment.remainingAmount = .zero
  
                } else { 
                    contexPayment.remainingAmount = NSDecimalNumber(decimal: remainingAmount)
                    
                }
                if (contexPayment.remainingAmount?.decimalValue ?? .zero) <= .zero {
                    markClosed(contexPayment)
                } else {
                    contexPayment.isClosed = false
                    contexPayment.closeDate = nil
                }
                
            } else { 
                markClosed(contexPayment)
                
            }
            
            try contex.save()

            let updatedPayment = PaymentMapper.toDomain(from: contexPayment)
            if updatedPayment.isClosed {
                NotificationManager.shared.removeNotification(id: updatedPayment.id)
            } else {
                NotificationManager.shared.scheduleNotification(for: updatedPayment)
            }
        }
        
        
    }
}
