import SwiftUI

struct MainViewContentHeader: View {
    @Binding var payType: PayType 
    var monthlyTotal: String
    var oneTimeTotal: String

    private var payTypeLabel: String {
        switch payType {
        case .mounthly:
            return "Aylık ödemeler"
        case .oneTime:
            return "Tek seferlik ödemeler"
        }
    }

    private var selectedTotal: String {
        payType == .mounthly ? monthlyTotal : oneTimeTotal
    }

    var body: some View {
        VStack(alignment:.leading, spacing: 12){
            HStack{ 
                Text("Borçlar")
                    .font(.appTitle(20))
                    .foregroundStyle(.appYelow)
                Spacer()
                HStack(spacing: 14){
                    Button { 
                        payType = .mounthly
                    } label: {
                        Text("Aylık")
                            .font(.appBody(12))
                            .fontWeight(payType == .mounthly ? .bold : .regular)
                            .foregroundStyle(payType == .mounthly ? .appYelow : .appGray)
                    }
                    .buttonStyle(.plain)
                    
                    Button { 
                        payType = .oneTime
                    } label: {
                        Text("Tek sefer")
                            .font(.appBody(12))
                            .fontWeight(payType == .oneTime ? .bold : .regular)
                            .foregroundStyle(payType == .oneTime ? .appYelow : .appGray)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            HStack(spacing: 4){ 
                Text(payType == .mounthly ? "Düzenli" : "Tek seferlik")
                    .font(.appTitle(18))
                Text(payTypeLabel)
                    .font(.appCaption(13))
                Spacer()
                Text(selectedTotal)
                    .font(.appBody(13))
                    .foregroundStyle(.appMint)
            }
            .foregroundStyle(.white.opacity(0.92))
        }
        .padding(.top, 6)
    }
}
