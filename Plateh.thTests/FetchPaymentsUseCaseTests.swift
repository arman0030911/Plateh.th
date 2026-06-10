import XCTest
@testable import Plateh_th

final class FetchPaymentsUseCaseTests: XCTestCase {
    private let dateFormatter = ISO8601DateFormatter()

    private func makePayment(id: String = "test-1") -> Payment {
        Payment(
            id: id,
            type: .monthly,
            title: "Test",
            description: "",
            paymentAmount: 1000,
            totalAmount: 12000,
            dueDay: 15,
            dueDate: nil,
            isNotificationEnabled: false,
            createdAt: dateFormatter.string(from: Date()),
            lastPay: nil,
            storedRemainingAmount: 11000,
            isClosedStored: false,
            closeDate: nil
        )
    }

    func testExecuteReturnsPayments() async throws {
        let mockPayments = [makePayment(id: "1"), makePayment(id: "2")]
        let repo = MockFetchPaymentsRepository(result: .success(mockPayments))
        let useCase = FetchPaymentsUseCaseImpl(repository: repo)

        let payments = try await useCase.execute(from: nil, includeClosed: false)

        XCTAssertEqual(payments.count, 2)
        XCTAssertEqual(payments[0].id, "1")
        XCTAssertEqual(payments[1].id, "2")
    }

    func testExecuteThrowsError() async {
        let repo = MockFetchPaymentsRepository(result: .failure(NSError(domain: "test", code: -1)))
        let useCase = FetchPaymentsUseCaseImpl(repository: repo)

        do {
            _ = try await useCase.execute(from: nil, includeClosed: false)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).code, -1)
        }
    }

    func testExecuteWithDateFilter() async throws {
        let mockPayments = [makePayment(id: "1")]
        let repo = MockFetchPaymentsRepository(result: .success(mockPayments))
        let useCase = FetchPaymentsUseCaseImpl(repository: repo)

        let date = Date()
        let payments = try await useCase.execute(from: date, includeClosed: true)

        XCTAssertEqual(payments.count, 1)
        XCTAssertEqual(repo.lastDate, date)
        XCTAssertTrue(repo.lastIncludeClosed ?? false)
    }
}

private final class MockFetchPaymentsRepository: FetchPaymentsRepository {
    let result: Result<[Payment], Error>
    var lastDate: Date?
    var lastIncludeClosed: Bool?

    init(result: Result<[Payment], Error>) {
        self.result = result
    }

    func fetchPayments(from date: Date?, includeClosed: Bool) async throws -> [Payment] {
        lastDate = date
        lastIncludeClosed = includeClosed
        switch result {
        case .success(let payments):
            return payments
        case .failure(let error):
            throw error
        }
    }
}
