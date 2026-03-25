//
//  PaymentsView.swift
//  Plateh.th
//
//  Created by Adis on 8.03.2026.
//

import SwiftUI

struct PaymentsView: View {
    @Binding var path: NavigationPath
    @StateObject var viewModel = Assembly.createPaymentsViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            HeaderView(
                page: HeaderViewContent(
                    totalPrice: viewModel.payments.map(\.remainingAmount).reduce(0, +).currencyText,
                    title: "Ödemeler",
                    date: (viewModel.date ?? Date()).withoutDayMonthYear,
                    pageType: .paymentList
                ),
                date: $viewModel.date
            )
            .zIndex(1)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 19) {
                    if viewModel.payments.isEmpty {
                        EmptyPaymentsView(
                            title: "Odeme bulunamadi",
                            subtitle: "Secilen tarih araliginda kayitli bir odeme yok."
                        )
                    } else {
                        ForEach(viewModel.payments, id: \.id) { payment in
                            PaymentCards(
                                path: $path,
                                action: {
                                    viewModel.setPayment(payment: payment)
                                },
                                payment: payment,
                                referenceDate: viewModel.date ?? .now
                            )
                        }
                    }
                }
                .padding(.top, 150)
                .padding(.bottom, 70)
            }
        }
        .padding(.horizontal, 20)
        .background(.appBlack)
        .onAppear{
            viewModel.fetchPayments()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
