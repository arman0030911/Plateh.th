import Foundation

protocol UpdatePaymentRepository: AnyObject {
    func updateNotification(id: String, isEnabled: Bool) throws
    func closePayment(id: String) throws
    func deleteLastPayment(id: String) throws
}
