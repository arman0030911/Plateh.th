import Foundation

protocol FetchPaymentDataSource {
    func fetchPayments(date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void)
}
