
import Foundation

class FetchPaymentsRepositoryImpl: FetchPaymentsRepository {
    private let dataSource: FetchPaymentDataSource

    init(dataSource: FetchPaymentDataSource) {
        self.dataSource = dataSource
    }

   ///
    
    func fetchPayments(from date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void) {
        dataSource.fetchPayments(date: date, includeClosed: includeClosed, completion: completion)
    }
}
