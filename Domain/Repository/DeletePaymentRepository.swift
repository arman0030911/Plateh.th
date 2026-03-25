import Foundation

protocol DeletePaymentRepository: AnyObject {
    func deletePayment(id: String) throws
}
