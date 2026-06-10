import XCTest
@testable import Plateh_th

final class PaymentStatusTests: XCTestCase {
    private let dateFormatter = ISO8601DateFormatter()

    private let now = Date()

    private func makePayment(
        type: PayType = .monthly,
        totalAmount: Double = 10000,
        paymentAmount: Double = 1000,
        dueDay: Int? = 15,
        lastPay: Date? = nil,
        isClosedStored: Bool = false,
        storedRemainingAmount: Double? = nil
    ) -> Payment {
        Payment(
            id: UUID().uuidString,
            type: type,
            title: "Test",
            description: "",
            paymentAmount: paymentAmount,
            totalAmount: totalAmount,
            dueDay: dueDay,
            dueDate: nil,
            isNotificationEnabled: false,
            createdAt: dateFormatter.string(from: Date()),
            lastPay: lastPay.map { dateFormatter.string(from: $0) },
            storedRemainingAmount: storedRemainingAmount,
            isClosedStored: isClosedStored,
            closeDate: nil
        )
    }

    func testUnpaidMonthlyShowsPayButton() {
        let payment = makePayment(type: .monthly, lastPay: nil)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertTrue(status.isShowPaymentButton)
        XCTAssertFalse(status.isPaid)
        XCTAssertFalse(status.isClosed)
    }

    func testClosedPaymentHidesPayButton() {
        let payment = makePayment(type: .monthly, lastPay: now, isClosedStored: true, storedRemainingAmount: 0)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertFalse(status.isShowPaymentButton)
        XCTAssertTrue(status.isClosed)
    }

    func testClosedPaymentHasCompletedBadge() {
        let payment = makePayment(type: .monthly, lastPay: now, isClosedStored: true, storedRemainingAmount: 0)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertEqual(status.badgeTitle, "Durum")
        XCTAssertEqual(status.badgeValue, "Tamamlandı")
    }

    func testPaidMonthlyThisMonth() {
        let payment = makePayment(type: .monthly, lastPay: now)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertTrue(status.isPaid)
        XCTAssertFalse(status.isShowPaymentButton)
    }

    func testOneTimeUnpaidShowsPay() {
        let payment = makePayment(type: .oneTime, totalAmount: 5000, paymentAmount: 5000, lastPay: nil)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertTrue(status.isShowPaymentButton)
        XCTAssertFalse(status.isPaid)
    }

    func testOneTimePaidHidesPay() {
        let payment = makePayment(type: .oneTime, totalAmount: 5000, paymentAmount: 5000, lastPay: now)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertFalse(status.isShowPaymentButton)
        XCTAssertTrue(status.isPaid)
    }

    func testCardColorIsRedWhenUnpaid() {
        let payment = makePayment(type: .monthly, lastPay: nil)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertEqual(status.cardColor, .appRed)
    }

    func testCardColorIsMintWhenPaid() {
        let payment = makePayment(type: .monthly, lastPay: now)
        let status = PaymentStatus(payment: payment, referenceDate: now)
        XCTAssertEqual(status.cardColor, .appMint)
    }
}
