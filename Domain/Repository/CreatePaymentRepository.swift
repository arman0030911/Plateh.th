

import Foundation

protocol CreatePaymentRepository: AnyObject{
    func createPayment(payment: Payment) throws
}
