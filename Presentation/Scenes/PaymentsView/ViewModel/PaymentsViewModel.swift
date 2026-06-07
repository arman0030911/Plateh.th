import Foundation
import Combine
import SwiftUI

@MainActor
class PaymentsViewModel: ObservableObject { 
    // MARK: - State

    @Published var payments: [Payment] = []
    @Published var date: Date? = .now {
        didSet { 
            fetchPayments()
        }
    }

    // MARK: - Dependencies

    private let fetchUseCase: FetchPaymentsUseCase 
    private let setUseCase: SetPaymentUseCase

    init(fetchUseCase: FetchPaymentsUseCase, setUseCase: SetPaymentUseCase) {
        self.fetchUseCase = fetchUseCase
        self.setUseCase = setUseCase
    }

    // MARK: - Actions

    func fetchPayments() {
        Task { @MainActor in
            do {
                payments = try await fetchUseCase.execute(from: date, includeClosed: true)
            } catch {
                AppLogger.error(error, context: "Payments screen loading")
            }
        }
    }

    func setPayment(payment: Payment) {
        do {
            try setUseCase.execute(payment: payment)
            fetchPayments()
        } catch {
            AppLogger.error(error, context: "Payments screen update")
        }
    }
}
