import Foundation

protocol SetPaymentDataSource: AnyObject{ 
    func setPayment(payment: Payment ) throws
}
