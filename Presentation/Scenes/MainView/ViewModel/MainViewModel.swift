import Foundation 
import Combine 

@MainActor 
class MainViewModel: ObservableObject {
    // MARK: - Dependencies

    private let fetchUseCase: FetchPaymentsUseCase
    private let setUseCase: SetPaymentUseCase

    init(FetchUseCase: FetchPaymentsUseCase, setUseCase: SetPaymentUseCase) {
        self.fetchUseCase = FetchUseCase 
        self.setUseCase = setUseCase 
    }

    // MARK: - State

    @Published var payments: [Payment] = []

    // MARK: - Derived State

    var totalDebt: Double {
        payments.map(\.remainingAmount).reduce(0, +)
    }

    var monthlyDebt: Double {
        payments
            .filter { $0.type == .monthly }
            .map(\.remainingAmount)
            .reduce(0, +)
    }

    var oneTimeDebt: Double {
        payments
            .filter { $0.type == .oneTime }
            .map(\.remainingAmount)
            .reduce(0, +)
    }

    // MARK: - Actions

    func fetchPayments() {
        Task { @MainActor in
            do {
                payments = try await fetchUseCase.execute(from: nil, includeClosed: false)
            } catch {
                AppLogger.error(error, context: "Main payments loading")
            }
        }
    }

    func setPayment(payment: Payment) {
        do { 
            try setUseCase.execute(payment: payment) 
            fetchPayments()
        } catch {
            AppLogger.error(error, context: "Main payment update")
        }
    }
}
