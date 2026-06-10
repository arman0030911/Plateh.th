import SwiftUI 


struct PaymentCards: View  {
    @Binding var path: NavigationPath
    var action: () -> Void
    var payment:  Payment
    var referenceDate: Date = .now

    private var cardColor: Color {
        PaymentStatus(payment: payment, referenceDate: referenceDate).cardColor
    }

    private var status: PaymentStatus {
        PaymentStatus(payment: payment, referenceDate: referenceDate)
    }

    private var subtitleText: String {
        status.subtitleText
    }

    private var amountLabelText: String {
        switch payment.type {
        case .monthly:
            return "/ ay"
        case .oneTime:
            return "/ tek ödeme"
        }
    }

    private var isClosed: Bool {
        payment.isClosed
    }

    private var topStatusText: String {
        if isClosed {
            return "Tamamlanan ödeme"
        }
        return payment.type == .monthly ? "Aylık ödeme" : "Tek seferlik ödeme"
    }

    var body: some View {
        VStack(alignment:.leading, spacing:16){
            VStack(alignment:.leading, spacing:12){
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment:.leading, spacing:6){
                        Text(topStatusText)
                            .font(.appCaption(11))
                            .foregroundStyle(.appBlack.opacity(0.58))
                            .textCase(.uppercase)
                        Text(payment.title)
                            .font(.appTitle(23))
                            .foregroundStyle(.appBlack)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 12)
                    statusBadge
                }

                Text(payment.description.isEmpty ? "Açıklama eklenmedi" : payment.description)
                    .font(.appCaption(12))
                    .foregroundStyle(.appBlack.opacity(0.68))
                    .lineLimit(2)

                HStack(alignment: .lastTextBaseline) {
                    HStack(spacing: 5){
                        Text((payment.type == .monthly ? payment.paymentAmount : payment.totalAmount).currencyText)
                            .font(.appTitle(18))
                        Text(amountLabelText)
                            .font(.appCaption(14))
                    }
                    .foregroundStyle(.appBlack)
                    Spacer()
                    Text(payment.type == .monthly ? "Toplam \(payment.totalAmount.currencyText)" : subtitleText)
                        .font(.appCaption(12))
                        .foregroundStyle(.appBlack.opacity(0.58))
                } 
            }
            HStack(spacing:8){
                if status.isShowPaymentButton {
                    FullButton(text: "Öde", fillColor: .white, textcolor: .black) {
                        action()
                    }
                } else {
                    SolidButton(
                        text: "Ödendi",
                        solidColor: .appBlack.opacity(0.18),
                        backRoundColor: .clear,
                        textColor: .appBlack.opacity(0.5)
                    )
                    .disabled(true)
                }
                SolidButton(text: "Detaylar", solidColor: .appBlack, backRoundColor: .clear, textColor: .appBlack) {
                    path.append(NavigationPage.details(paymentId: payment.id))
                }
                
            }
            
        }
        .padding(.horizontal,16)
        .padding(.vertical, 18)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
        .shadow(color: cardColor.opacity(0.14), radius: 16, y: 8)
    }

    private var statusBadge: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(status.badgeTitle)
                .font(.appCaption(10))
                .foregroundStyle(.appGray.opacity(0.72))
            Text(status.badgeValue)
                .font(.appBody(12))
                .foregroundStyle(.appGray)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 7)
        .background(.appBlack.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius))
    }
}
