import Foundation

protocol DeletePaymentDataSource: AnyObject {
    func deletePayment(id: String) throws
}
