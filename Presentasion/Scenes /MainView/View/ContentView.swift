import SwiftUI

struct ContentView: View {
    @State var isShowAddView: Bool = false 
    @State var payType: PayType = .mounthly
    @StateObject var viewModel = Assembly.createMAinViewModel()
    @Binding var path: NavigationPath

    private var totalDebtText: String {
        viewModel.totalDebt.currencyText
    }

    private var currentDateText: String {
        Date.now.shortTurkishDisplay
    }

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
                            case .mounthly:
                                paymentsList(for: .mounthly)
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
    @ViewBuilder
    func paymentsList(for type: PayType) -> some View {
        let filteredPayments = viewModel.payments.filter { $0.type == type }

        if filteredPayments.isEmpty {
            EmptyPaymentsView(
                title: type == .mounthly ? "Aylik odeme yok" : "Tek seferlik odeme yok",
                subtitle: type == .mounthly
                    ? "Yeni bir kart ekleyip duzenli odemelerini buradan takip edebilirsin."
                    : "Tek seferlik odemeler burada gorunecek."
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
