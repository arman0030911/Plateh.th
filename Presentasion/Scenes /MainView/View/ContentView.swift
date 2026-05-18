import SwiftUI

struct ContentView: View {
    // MARK: - State

    @State var isShowAddView: Bool = false 
    @State var payType: PayType = .monthly
    @StateObject var viewModel = Assembly.createMainViewModel()
    @Binding var path: NavigationPath

    // MARK: - Derived Values

    private var totalDebtText: String {
        viewModel.totalDebt.currencyText
    }

    private var currentDateText: String {
        Date.now.shortTurkishDisplay
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top){ 
            HeaderView(page: HeaderViewContent(totalPrice: totalDebtText, title: "Toplam borç", date: currentDateText, pageType:.main), action: {
                isShowAddView.toggle() 
            }, date:.constant(.now))
            .zIndex(1)
            ScrollView(showsIndicators: false){ 
                
                VStack(alignment:.leading, spacing: 19){
                    MainViewContentHeader(
                        payType: $payType,
                        monthlyTotal: viewModel.monthlyDebt.currencyText,
                        oneTimeTotal: viewModel.oneTimeDebt.currencyText
                    )
                    
                    VStack(alignment:.leading, spacing: 19){ 
                        switch payType {
                            case .monthly:
                                paymentsList(for: .monthly)
                            case .oneTime:
                                paymentsList(for: .oneTime)
                        }
                    }
                    
                }
                .padding(.top, 150)
                .padding(.bottom,70)
                
            }  
        }
        .padding(.horizontal,20)
        .background(.appBlack)
        .sheet(isPresented: $isShowAddView, onDismiss: {
            viewModel.fetchPayments()
        }) {
            AddView()
        }
        .onAppear{
            viewModel.fetchPayments()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension ContentView {
    // MARK: - Helpers

    @ViewBuilder
    func paymentsList(for type: PayType) -> some View {
        let filteredPayments = viewModel.payments.filter { $0.type == type }

        if filteredPayments.isEmpty {
            EmptyPaymentsView(
                title: type == .monthly ? "Aylık ödeme yok" : "Tek seferlik ödeme yok",
                subtitle: type == .monthly
                    ? "Yeni bir kart ekleyip düzenli ödemelerini buradan takip edebilirsin."
                    : "Tek seferlik ödemeler burada görünecek."
            )
        } else {
            ForEach(filteredPayments, id: \.id) { item in
                PaymentCards(
                    path: $path,
                    action: {
                        viewModel.setPayment(payment: item)
                    },
                    payment: item,
                    referenceDate: .now
                )
            }
        }
    }
}
