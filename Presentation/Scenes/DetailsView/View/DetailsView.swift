import SwiftUI

struct DetailsView: View {
    // MARK: - State

    @State var isNotificationSelected: Bool = false
    @State private var isShowDeleteAlert = false
    @StateObject private var viewModel: DetailsViewModel
    var paymentId: String
    @Binding var path: NavigationPath

    // MARK: - Init

    init(paymentId: String, path: Binding<NavigationPath>) {
        self.paymentId = paymentId
        self._path = path
        self._viewModel = StateObject(wrappedValue: Assembly.createDetailsViewModel())
    }

    // MARK: - Helpers

    private func accentColor(for payment: Payment) -> Color {
        PaymentStatus(payment: payment).accentColor
    }

    private func infoText(for payment: Payment) -> String {
        if payment.description.isEmpty {
            return "Açıklama eklenmedi"
        }
        return payment.description
    }

    private func shouldShowRemainingAmount(for payment: Payment) -> Bool {
        payment.type == .monthly && payment.totalAmount > payment.paymentAmount
    }

    // MARK: - Body

    var body: some View {
        Group {
            if let payment = viewModel.payment {
                let status = PaymentStatus(payment: payment)
                VStack(alignment:.leading, spacing: 22){
                    header
                    
                    VStack(alignment:.leading, spacing: 6){
                        Text(payment.totalAmount.currencyText)
                            .font(.appDisplay(30))
                            .foregroundStyle(.white)
                        Text(payment.title)
                            .font(.appTitle(18))
                            .foregroundStyle(accentColor(for: payment))
                    }
                    .padding(.vertical, 16)
                   .navigationBarBackButtonHidden(true)
                    VStack(alignment:.leading, spacing: 26){
                        
                    VStack(alignment: .leading, spacing: 17) {
                        HStack(spacing: 16){
                            if payment.type == .monthly {
                                if shouldShowRemainingAmount(for: payment) {
                                    InfoTagsView(text:"Kalan \(payment.remainingAmount.currencyText)")
                                }
                                InfoTagsView(text:"Aylık \(payment.paymentAmount.currencyText)")
                            } else {
                                InfoTagsView(text:"Toplam \(payment.totalAmount.currencyText)")
                            }
                            
                        }
                        Text(infoText(for: payment))
                            .font(.appBody(14))
                            .foregroundStyle(AppTheme.mutedText)
                    }
                        
                    VStack(alignment: .leading, spacing: 20){
                            Divider()
                                .background(AppTheme.border)
                        
                        
                        HStack(spacing: 5){
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
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius))
                        }
                        .padding(.horizontal, 10)
                        
                        Divider()
                            .background(AppTheme.border)
                        
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
                        .padding(14)
                        .background(AppTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                                .stroke(AppTheme.border, lineWidth: 1)
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
                }
                .onChange(of: isNotificationSelected) { newValue in
                    viewModel.updateNotification(id: payment.id, isEnabled: newValue)
                }
                .alert("Hata", isPresented: .init(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )) {
                    Button("Tamam", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
            } else {
                ProgressView()
                    .tint(.appYelow)
            }
        }
        .task(id: paymentId) { @MainActor in
            viewModel.loadPayment(id: paymentId)
        }
    }
}

extension DetailsView{
    // MARK: - Header

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
            .alert("Ödemeyi sil?", isPresented: $isShowDeleteAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    if viewModel.deletePayment(id: paymentId) {
                        if !path.isEmpty {
                            path.removeLast()
                        }
                    }
                }
            } message: {
                Text("Bu ödeme tamamen silinecek.")
            }
        }
    }
}
