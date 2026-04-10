//
//  PaymentsViewModel.swift
//  Plateh.th
//
//  Created by Adis on 19.03.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class PaymentsViewModel: ObservableObject { 
    @Published var payments: [Payment] = []
    @Published var date: Date? = .now {
        didSet { 
            fetchPayments()
        }
    }
    
    private let fetchUseCase: FetchPaymentsUseCase 
    private let setUseCase: SetPaymentUseCase
    
    init(fetchUseCase: FetchPaymentsUseCase, setUseCase: SetPaymentUseCase) {
        self.fetchUseCase = fetchUseCase
        self.setUseCase = setUseCase
    }
    
    func fetchPayments() {
        fetchUseCase.execute(from: date, includeClosed: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.payments = success
                }
            case .failure(let error):
                print(error.localizedDescription)
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
