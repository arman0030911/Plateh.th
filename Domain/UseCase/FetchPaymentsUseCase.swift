import Foundation

protocol FetchPaymentsUseCase: AnyObject {
    func execute(from date: Date?, includeClosed: Bool) async throws -> [Payment]
}

class FetchPaymentsUseCaseImpl: FetchPaymentsUseCase {
    private let repository: FetchPaymentsRepository

    init(repository: FetchPaymentsRepository) {
        self.repository = repository
    }

    func execute(from date: Date?, includeClosed: Bool) async throws -> [Payment] {
        try await repository.fetchPayments(from: date, includeClosed: includeClosed)
    }
}
