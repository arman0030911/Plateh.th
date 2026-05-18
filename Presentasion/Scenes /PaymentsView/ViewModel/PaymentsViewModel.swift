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
        fetchUseCase.execute(from: date, includeClosed: true) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let success):
                Task { @MainActor in
                    self.payments = success
                }
            case .failure(let error):
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
