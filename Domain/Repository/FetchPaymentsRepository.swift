import Foundation

protocol FetchPaymentsRepository: AnyObject {
    func fetchPayments(from date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void)
}
