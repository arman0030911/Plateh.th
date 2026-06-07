import SwiftUI

struct PaymentsView: View {
    @Binding var path: NavigationPath
    @StateObject var viewModel = Assembly.createPaymentsViewModel()

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            HeaderView(
                page: HeaderViewContent(
                    totalPrice: viewModel.payments.map(\.remainingAmount).reduce(0, +).currencyText,
                    title: "Ödemeler",
                    date: (viewModel.date ?? Date()).monthYearString,
                    pageType: .paymentList
                ),
                date: $viewModel.date
            )
            .zIndex(1)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 19) {
                    if viewModel.payments.isEmpty {
                        EmptyPaymentsView(
                            title: "Ödeme bulunamadı",
                            subtitle: "Seçilen tarih aralığında kayıtlı bir ödeme yok."
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
