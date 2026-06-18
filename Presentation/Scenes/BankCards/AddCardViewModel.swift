import Foundation
import Combine

@MainActor
final class AddCardViewModel: ObservableObject {
    @Published var cardNumber: String = ""
    @Published var holderName: String = ""
    @Published var expiryMonth: String = ""
    @Published var expiryYear: String = ""
    @Published var cvv: String = ""
    @Published var errorMessage: String? = nil
    @Published var isSaving: Bool = false
    @Published var didSave: Bool = false

    private let repository: BankCardRepository

    init(repository: BankCardRepository? = nil) {
        // create default inside initializer body to avoid default-parameter main-actor init warning
        self.repository = repository ?? UserDefaultsBankCardRepository()
    }

    func validateAndSave() {
        let digits = cardNumber.filter { $0.isNumber }
        guard Luhn.validate(digits) else {
            errorMessage = "Kart numarası geçersiz"
            return
        }

        // Extract last4
        let last4 = String(digits.suffix(4))

        // Parse expiry
        let month = Int(expiryMonth) ?? 0
        let year = Int(expiryYear) ?? 0

        let card = BankCard(holderName: holderName, last4: last4, expiryMonth: month, expiryYear: year)

        // perform async save without blocking the caller
        Task { @MainActor in
            self.isSaving = true
            do {
                try await repository.save(card: card, cvv: cvv)
                // success: clear fields and notify view
                self.errorMessage = nil
                self.clearFields()
                self.didSave = true

                // auto-hide success after 2s
                Task.detached { [weak self] in
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                    await MainActor.run {
                        self?.didSave = false
                    }
                }
            } catch {
                self.errorMessage = "Kaydetme sırasında hata oluştu"
            }
            self.isSaving = false
        }
    }

    private func clearFields() {
        cardNumber = ""
        holderName = ""
        expiryMonth = ""
        expiryYear = ""
        cvv = ""
    }
}
