import Foundation

protocol FetchPaymentsRepository: AnyObject {
    func fetchPayments(from date: Date?, includeClosed: Bool) async throws -> [Payment]
}
