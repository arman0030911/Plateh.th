//
//  PeymentCards.swift
//  Plateh.th
//
//  Created by Adis on 6.03.2026.
//

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
        case .mounthly:
            return "/ ay"
        case .oneTime:
            return "/ tek ödeme"
        }
    }

    var body: some View {
        VStack(alignment:.leading, spacing:14){
            VStack(alignment:.leading, spacing:8){
                VStack(alignment:.leading, spacing:10){
                    VStack(alignment:.leading, spacing:4){
                        Text(payment.title)
                            .font(.appTitle(24))
                            .foregroundStyle(.appBlack)
                        
                        HStack(spacing: 5){
                            Text(subtitleText)
                                .font(.appCaption(12))
                            if payment.type == .mounthly {
                                Text("•")
                                    .font(.appCaption(12))
                                Text("Toplam \(payment.totalAmount.currencyText)")
                                    .font(.appCaption(12))
                            }
                            
                        }
                        .foregroundStyle(.appBlack.opacity(0.72))
                    }
                    Text(payment.description.isEmpty ? "Açıklama eklenmedi" : payment.description)
                        .font(.appCaption(12))
                        .foregroundStyle(.appBlack.opacity(0.76))
                        .lineLimit(2)
                    
                    
                }
                
                HStack {
                    HStack(spacing: 5){
                        Text((payment.type == .mounthly ? payment.paymentAmount : payment.totalAmount).currencyText)
                            .font(.appTitle(18))
                        Text(amountLabelText)
                            .font(.appCaption(14))
                    }
                    .foregroundStyle(.appBlack)
                    Spacer()
                    HStack(spacing: 5){ 
                        Text(status.badgeTitle)
                            .font(.appCaption(12))
                        Text(status.badgeValue)
                            .font(.appBody(12))
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(.appBlack.opacity(0.92))
                    .foregroundStyle(.appGray)
                    .clipShape(.capsule)
                    
                } 
            }
            HStack(spacing:4){
                if status.isShowPaymentButton {
                    FullButton(text: "Öde", filltcolor: .white, textcolor: .black) {
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
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            }
        }
     
}
