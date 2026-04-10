//
//  AddViewModel.swift
//  Plateh.th
//
//  Created by Adis on 14.03.2026.
//

import SwiftUI
import CoreData
import Combine

class AddViewModel: ObservableObject {
    private let createUseCase: CreatePaymentUseCase

    init(createUseCase: CreatePaymentUseCase) {
        self.createUseCase = createUseCase
    }

    // Formatter used to serialize dates to strings
    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    @Published var isNotificationSelected: Bool = false
    @Published var payType: PayType = .monthly

    @Published var isShowCalendar = false
    @Published var isAdded: Bool = false
    @Published var validationMessage: String?

    @Published var paymentName: String = ""
    @Published var description: String = ""
    @Published var paymanetAmount: String = ""
    @Published var totalAmount: String = ""
    @Published var date: Date = .now

    var canCreatePayment: Bool {
        validationError == nil
    }

    private var validationError: String? {
        let name = paymentName.trimmingCharacters(in: .whitespacesAndNewlines)
        let total = totalAmount.parsedAmountValue
        let monthly = paymanetAmount.parsedAmountValue

        if name.isEmpty {
            return "Odeme adi zorunlu."
        }

        if total <= 0 {
            return "Toplam tutar 0'dan buyuk olmali."
        }

        if payType == .monthly {
            if monthly <= 0 {
                return "Aylik odeme girmen gerekiyor."
            }

            if monthly > total {
                return "Aylik odeme toplam tutardan buyuk olamaz."
            }
        }

        return nil
    }

    func createNewPayment() {
        validationMessage = validationError
        guard validationMessage == nil else { return }

        do {
            let dayComponent = Calendar.current.component(.day, from: date)
            let parsedTotalAmount = totalAmount.parsedAmountValue
            let monthlyAmount = max(paymanetAmount.parsedAmountValue, 0)
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
            validationMessage = "Odeme eklenemedi. Lutfen tekrar dene."
            print(error.localizedDescription)
        }
    }
}
