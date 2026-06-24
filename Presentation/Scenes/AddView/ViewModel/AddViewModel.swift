import SwiftUI
import CoreData
import Combine

class AddViewModel: ObservableObject {
    // MARK: - Dependencies

    private let createUseCase: CreatePaymentUseCase

    init(createUseCase: CreatePaymentUseCase) {
        self.createUseCase = createUseCase
    }

    // MARK: - Formatting

    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    // MARK: - State

    @Published var isNotificationSelected: Bool = false
    @Published var payType: PayType = .monthly

    @Published var isShowCalendar = false
    @Published var isAdded: Bool = false
    @Published var validationMessage: String?

    @Published var paymentName: String = ""
    @Published var description: String = ""
    @Published var paymentAmount: String = ""
    @Published var totalAmount: String = ""
    @Published var date: Date = .now

    // MARK: - Validation

    var canCreatePayment: Bool {
        validationError == nil
    }

    private var validationError: String? {
        let name = paymentName.trimmingCharacters(in: .whitespacesAndNewlines)
        let total = totalAmount.parsedAmountValue
        let monthly = paymentAmount.parsedAmountValue

        if name.isEmpty {
            return "Ödeme adı zorunludur."
        }

        if total <= 0 {
            return "Toplam tutar 0'dan büyük olmalıdır."
        }

        if payType == .monthly {
            if monthly <= 0 {
                return "Aylık ödeme girmeniz gerekir."
            }

            if monthly > total {
                return "Aylık ödeme toplam tutardan büyük olamaz."
            }
        }

        return nil
    }

    // MARK: - Actions

    func createNewPayment() {
        validationMessage = validationError
        guard validationMessage == nil else { return }

        do {
            let dayComponent = Calendar.current.component(.day, from: date)
            let parsedTotalAmount = totalAmount.parsedAmountValue
            let monthlyAmount = max(paymentAmount.parsedAmountValue, 0)
            let parsedPaymentAmount = payType == .monthly
                ? (monthlyAmount > 0 ? monthlyAmount : parsedTotalAmount)
                : parsedTotalAmount

            let dueDateString = isoFormatter.string(from: date)
            let createdAtString = isoFormatter.string(from: Date())

            let payment = Payment(
                id: UUID().uuidString,
                type: payType,
                title: paymentName,
                description: description,
                paymentAmount: parsedPaymentAmount,
                totalAmount: parsedTotalAmount,
                dueDay: dayComponent,
                dueDate: dueDateString,
                isNotificationEnabled: isNotificationSelected,
                createdAt: createdAtString,
                lastPay: nil,
                storedRemainingAmount: parsedTotalAmount,
                isClosedStored: false,
                closeDate: nil
            )

            try createUseCase.execute(payment: payment)
            isAdded.toggle()
        } catch {
            validationMessage = "Ödeme eklenemedi. Lütfen tekrar deneyin."
            AppLogger.error(error, context: "Payment creation")
        }
    }
}
