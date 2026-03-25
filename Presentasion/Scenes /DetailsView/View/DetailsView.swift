

import SwiftUI 
import Combine

struct DetailsView: View {
    @State var isNotificationSelected: Bool = false
    @State private var isShowDeleteAlert = false
    @StateObject private var viewModel: DetailsViewModel
    var paymentId: String  // Изменено: было payment: Payment
    @Binding var path: NavigationPath
    
    // Новый init для работы с id
    init(paymentId: String, path: Binding<NavigationPath>) {
        self.paymentId = paymentId
        self._path = path
        self._viewModel = StateObject(wrappedValue: Assembly.createDetailsViewModel())
    }

    private func accentColor(for payment: Payment) -> Color {
        PaymentStatus(payment: payment).accentColor
    }

    private func infoText(for payment: Payment) -> String {
        if payment.description.isEmpty {
            return "Açıklama eklenmedi"
        }
        return payment.description
    }
    
    var body: some View {
        if let payment = viewModel.payment {
            let status = PaymentStatus(payment: payment)
            VStack(alignment:.leading, spacing: 22){
                header
                
                VStack(alignment:.leading){
                    VStack(alignment:.leading, spacing: 2){
                        Text(payment.totalAmount.currencyText)
                            .font(.appDisplay(28))
                            .foregroundStyle(.white)
                        Text(payment.title)
                            .font(.appTitle(18))
                            .foregroundStyle(accentColor(for: payment))
                        
                    }
                    .padding(.vertical, 18)
                    
                }
               .navigationBarBackButtonHidden(true)
                VStack(alignment:.leading, spacing: 26){
                    
                VStack(alignment: .leading, spacing: 17) {
                    HStack(spacing: 16){
                        if payment.type == .mounthly {
                            InfoTagsView(text:"Kalan \(payment.remainingAmount.currencyText)")
                            InfoTagsView(text:"Aylık \(payment.paymentAmount.currencyText)")
                        } else {
                            InfoTagsView(text:"Toplam \(payment.totalAmount.currencyText)")
                        }
                        
                    }
                    Text(infoText(for: payment))
                        .font(.appBody(14))
                        .foregroundStyle(.appMint)
                }
                    
                VStack(alignment: .leading, spacing: 20){
                        Divider()
                            .background(.appGray)
                    
                    
                    HStack(spacing: 5){ 
                        
                        switch payment.type {
                            case .mounthly:
                                Text(status.detailsTitle)
                                    .font(.appBody(14))
                                    .foregroundStyle(accentColor(for: payment))
                                    .offset(y: -3)
                                Spacer()
                                
                                HStack(spacing: 4){
                                    Text(status.detailsStateText)
                                        .font(.appCaption(12))
                                    Text(status.detailsDateText)
                                        .font(.appCaption(12))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(status.accentColor)
                                .clipShape(Capsule())
                            case .oneTime:
                                Text(status.detailsTitle)
                                    .font(.appBody(14))
                                    .foregroundStyle(accentColor(for: payment))
                                    .offset(y: -3)
                                Spacer()
                                
                                HStack(spacing: 4){
                                    Text(status.detailsStateText)
                                        .font(.appCaption(12))
                                    Text(status.detailsDateText)
                                        .font(.appCaption(12))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(status.accentColor)
                                .clipShape(Capsule())
                        }
                
                        
                        
                        
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                        .background(.appGray)
                    
                    HStack{
                        Text("Ödeme bildirimi")
                            .font(.appBody(14))
                            .foregroundStyle(accentColor(for: payment))
                            .offset(y: -4)
                        Spacer()
                        RadioButtonView(isSelected: $isNotificationSelected)
                    }
                    .padding(.horizontal, 10)
                
                    
                    } 
                    
                }

                

                
                Spacer()
                
            
                VStack(alignment:.leading, spacing: 18) {
                    if payment.isClosed {
                        SolidButton(
                            text: "Ödeme tamamlandı",
                            solidColor: .appMint.opacity(0.35),
                            backRoundColor: .clear,
                            textColor: .appMint
                        )
                        .disabled(true)
                    } else {
                        SolidButton(text: "Borcu kapat", solidColor: .appYelow, textColor: .appBlack, isFull: true) {
                            viewModel.closePayment(id: payment.id)
                        }
                    }

                    SolidButton(text:"Son ödemeyi sil", solidColor:.appYelow, textColor: .appYelow) {
                        viewModel.removeLastPayment(id: payment.id)
                    }
                    .disabled(payment.lastPay == nil)
                    .opacity(payment.lastPay == nil ? 0.5 : 1)
                }
            }
            .padding(.horizontal,20)
            .background(.appBlack)
            .onAppear {
                isNotificationSelected = payment.isNotificationEnabled
                viewModel.loadPayment(id: paymentId)
            }
            .onChange(of: isNotificationSelected) { _, newValue in
                viewModel.updateNotification(id: payment.id, isEnabled: newValue)
            }
        } else {
            ProgressView()
                .onAppear {
                    viewModel.loadPayment(id: paymentId)
                }
        }
    }
}

extension DetailsView{
    var header: some View{
        HStack{ 
            Button { 
                path.removeLast()
            } label: { 
                Image(systemName:"chevron.left")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.appYelow)
                    .frame(width: 20, height: 20)
                    
                
            }
            .buttonStyle(.plain)
            Spacer()
            
            Text("Ödeme detayı")
                .font(.appTitle(18))
                .foregroundStyle(.appYelow)
            
            Spacer()
            Button { 
                isShowDeleteAlert = true
            } label: { 
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.appYelow)
                    .frame(width: 20, height: 20)
                    
                
                
            }
            .buttonStyle(.plain)
            .alert("Odemeyi sil?", isPresented: $isShowDeleteAlert) {
                Button("Iptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    viewModel.deletePayment(id: paymentId)
                    if !path.isEmpty {
                        path.removeLast()
                    }
                }
            } message: {
                Text("Bu odeme tamamen silinecek.")
            }
            


        }
    }
}

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
        fetchUseCase.execute(from: nil, includeClosed: true) { [weak self] result in
            guard let self = self else { return }
            if case .success(let payments) = result {
                DispatchQueue.main.async {
                    self.payment = payments.first { $0.id == id }
                }
            }
        }
    }

    func closePayment(id: String) {
        do {
            try updateUseCase.closePayment(id: id)
            loadPayment(id: id)
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeLastPayment(id: String) {
        do {
            try updateUseCase.deleteLastPayment(id: id)
            loadPayment(id: id)
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateNotification(id: String, isEnabled: Bool) {
        do {
            try updateUseCase.updateNotification(id: id, isEnabled: isEnabled)
            loadPayment(id: id)
        } catch {
            print(error.localizedDescription)
        }
    }

    func deletePayment(id: String) {
        do {
            try deleteUseCase.execute(id: id)
        } catch {
            print(error.localizedDescription)
        }
    }
}
