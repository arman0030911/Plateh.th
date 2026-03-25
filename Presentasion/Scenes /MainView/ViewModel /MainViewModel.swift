import Foundation 
import Combine 

@MainActor 
class MainViewModel: ObservableObject {
    
    private let fetchUseCase: FetchPaymentsUseCase
    private let setUseCase: SetPaymentUseCase
    
    init(FetchUseCase: FetchPaymentsUseCase, setUseCase: SetPaymentUseCase) {
        self.fetchUseCase = FetchUseCase 
        self.setUseCase = setUseCase 
    }
    
    @Published var payments: [Payment] = []

    var totalDebt: Double {
        payments.map(\.remainingAmount).reduce(0, +)
    }

    var monthlyDebt: Double {
        payments
            .filter { $0.type == .mounthly }
            .map(\.remainingAmount)
            .reduce(0, +)
    }

    var oneTimeDebt: Double {
        payments
            .filter { $0.type == .oneTime }
            .map(\.remainingAmount)
            .reduce(0, +)
    }
    
    func fetchPayments() {
        fetchUseCase.execute(from: nil, includeClosed: false) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                // Явно выполняем присвоение на главном акторе
                Task { @MainActor in
                    self.payments = success
                }
            case .failure(let failure):
                print("Ошибка: \(failure.localizedDescription)")
            }
        }
    }
     
    func setPayment(payment: Payment) {
        do { 
            try setUseCase.execute(payment: payment) 
            fetchPayments()
        } catch {
            print(error.localizedDescription)
        }
    }
}
