import Foundation

class FetchPaymentsRepositoryImpl: FetchPaymentsRepository {
    private let dataSource: FetchPaymentDataSource

    init(dataSource: FetchPaymentDataSource) {
        self.dataSource = dataSource
    }

    func fetchPayments(from date: Date?, includeClosed: Bool) async throws -> [Payment] {
        try await dataSource.fetchPayments(date: date, includeClosed: includeClosed)
    }
}
