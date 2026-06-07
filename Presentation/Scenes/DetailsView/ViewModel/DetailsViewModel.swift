import Foundation
import Combine

@MainActor
class DetailsViewModel: ObservableObject {
    @Published var payment: Payment?
    private let fetchUseCase: FetchPaymentsUseCase
    private let updateUseCase: UpdatePaymentUseCase
    private let deleteUseCase: DeletePaymentUseCase

    init(fetchUseCase: FetchPaymentsUseCase, updateUseCase: UpdatePaymentUseCase, deleteUseCase: DeletePaymentUseCase) {
        self.fetchUseCase = fetchUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
    }

    func loadPayment(id: String) {
        Task { @MainActor in
            do {
                let payments = try await fetchUseCase.execute(from: nil, includeClosed: true)
                payment = payments.first { $0.id == id }
            } catch {
                AppLogger.error(error, context: "Details payment loading")
            }
        }
    }

    func closePayment(id: String) {
        do {
            try updateUseCase.closePayment(id: id)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Closing payment")
        }
    }

    func removeLastPayment(id: String) {
        do {
            try updateUseCase.deleteLastPayment(id: id)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Deleting last payment")
        }
    }

    func updateNotification(id: String, isEnabled: Bool) {
        do {
            try updateUseCase.updateNotification(id: id, isEnabled: isEnabled)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Updating payment notification")
        }
    }

    func deletePayment(id: String) {
        do {
            try deleteUseCase.execute(id: id)
        } catch {
            AppLogger.error(error, context: "Deleting payment")
        }
    }
}
