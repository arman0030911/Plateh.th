import XCTest
@testable import Plateh_th

final class PaymentDomainTests: XCTestCase {
    private let dateFormatter = ISO8601DateFormatter()

    private func makePayment(
        type: PayType = .monthly,
        totalAmount: Double = 10000,
        paymentAmount: Double = 1000,
        lastPay: String? = nil,
        storedRemainingAmount: Double? = nil,
        isClosedStored: Bool = false
    ) -> Payment {
        Payment(
            id: UUID().uuidString,
            type: type,
            title: "Test",
            description: "",
            paymentAmount: paymentAmount,
            totalAmount: totalAmount,
            dueDay: nil,
            dueDate: nil,
            isNotificationEnabled: false,
            createdAt: dateFormatter.string(from: Date()),
            lastPay: lastPay,
            storedRemainingAmount: storedRemainingAmount,
            isClosedStored: isClosedStored,
            closeDate: nil
        )
    }

    // MARK: - Monthly Payment

    func testMonthlyPaymentRemainingAmountDefaultsToTotal() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, storedRemainingAmount: nil)
        XCTAssertEqual(payment.remainingAmount, 10000)
    }

    func testMonthlyPaymentRemainingAmountFromStored() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, storedRemainingAmount: 4000)
        XCTAssertEqual(payment.remainingAmount, 4000)
    }

    func testMonthlyPaymentRemainingAmountDoesNotGoBelowZero() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, storedRemainingAmount: -100)
        XCTAssertEqual(payment.remainingAmount, 0)
    }

    func testMonthlyPaymentIsNotClosedWhenActive() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, storedRemainingAmount: 5000)
        XCTAssertFalse(payment.isClosed)
    }

    func testMonthlyPaymentIsClosedWhenRemainingZero() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, storedRemainingAmount: 0)
        XCTAssertTrue(payment.isClosed)
    }

    func testMonthlyPaymentIsClosedWhenStoredClosed() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, isClosedStored: true)
        XCTAssertTrue(payment.isClosed)
    }

    // MARK: - OneTime Payment

    func testOneTimePaymentRemainingAmountEqualsTotalWhenNotPaid() {
        let payment = makePayment(type: .oneTime, totalAmount: 5000, lastPay: nil)
        XCTAssertEqual(payment.remainingAmount, 5000)
    }

    func testOneTimePaymentRemainingAmountIsZeroWhenPaid() {
        let payment = makePayment(type: .oneTime, totalAmount: 5000, lastPay: dateFormatter.string(from: Date()))
        XCTAssertEqual(payment.remainingAmount, 0)
    }

    func testOneTimePaymentIsClosedWhenRemainingZero() {
        let payment = makePayment(type: .oneTime, totalAmount: 5000, lastPay: dateFormatter.string(from: Date()))
        XCTAssertTrue(payment.isClosed)
    }

    // MARK: - isPaid

    func testMonthlyPaymentIsPaidWhenClosed() {
        let payment = makePayment(type: .monthly, totalAmount: 10000, isClosedStored: true)
        XCTAssertTrue(payment.isPaid)
    }
}
