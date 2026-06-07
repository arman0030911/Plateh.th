import Foundation

protocol FetchPaymentDataSource {
    func fetchPayments(date: Date?, includeClosed: Bool) async throws -> [Payment]
}
