import Foundation
import Combine

@MainActor
class DetailsViewModel: ObservableObject {
    @Published var payment: Payment?
    @Published var errorMessage: String?
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
                payment = try await fetchUseCase.execute(from: nil, includeClosed: true).first { $0.id == id }
            } catch {
                AppLogger.error(error, context: "Details payment loading")
            }
        }
    }

    func closePayment(id: String) {
        errorMessage = nil
        do {
            try updateUseCase.closePayment(id: id)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Closing payment")
            errorMessage = "Ödeme kapatılamadı."
        }
    }

    func removeLastPayment(id: String) {
        errorMessage = nil
        do {
            try updateUseCase.deleteLastPayment(id: id)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Deleting last payment")
            errorMessage = "Son ödeme silinemedi."
        }
    }

    func updateNotification(id: String, isEnabled: Bool) {
        errorMessage = nil
        do {
            try updateUseCase.updateNotification(id: id, isEnabled: isEnabled)
            loadPayment(id: id)
        } catch {
            AppLogger.error(error, context: "Updating payment notification")
            errorMessage = "Bildirim ayarı güncellenemedi."
        }
    }

    func deletePayment(id: String) -> Bool {
        errorMessage = nil
        do {
            try deleteUseCase.execute(id: id)
            return true
        } catch {
            AppLogger.error(error, context: "Deleting payment")
            errorMessage = "Ödeme silinemedi."
            return false
        }
    }
}
