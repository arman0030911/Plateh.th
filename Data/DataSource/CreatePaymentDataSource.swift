

import Foundation

protocol CreatePaymentDataSource {
    func createNewPayment(payment: Payment) throws
}
