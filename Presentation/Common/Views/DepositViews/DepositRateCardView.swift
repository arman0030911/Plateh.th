import SwiftUI

struct DepositRateCardView: View {
    var rate: DepositRate
    var principalAmount: Double?

    private var subtitleText: String {
        var parts = ["\(rate.termDays) gün", rate.currency]
        if let minAmount = rate.minAmount {
            parts.append("Min \(rate.currencyOption.symbol)\(minAmount.formattedWithoutDecimals)")
        }
        return parts.joined(separator: " • ")
    }

    private var updatedText: String? {
        guard let updatedAt = rate.updatedAt else { return nil }
        return "Güncel \(updatedAt.shortTurkishDisplay)"
    }

    private var estimatedProfit: Double? {
        guard let principalAmount, principalAmount > 0 else { return nil }
        return principalAmount * (rate.interestRate / 100) * Double(rate.termDays) / 365
    }

    private var maturityAmount: Double? {
        guard let estimatedProfit, let principalAmount else { return nil }
        return principalAmount + estimatedProfit
    }

    private var principalText: String? {
        guard let principalAmount, principalAmount > 0 else { return nil }
        return "Ana para \(principalAmount.currencyText(symbol: rate.currencyOption.symbol))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Banka teklifi")
                            .font(.appCaption(11))
                            .foregroundStyle(.appBlack.opacity(0.58))
                            .textCase(.uppercase)
                        Text(rate.bank.name)
                            .font(.appTitle(24))
                            .foregroundStyle(.appBlack)
                            .lineLimit(2)

                        Text(subtitleText)
                            .font(.appCaption(12))
                            .foregroundStyle(.appBlack.opacity(0.72))
                    }

                    if let updatedText {
                        Text(updatedText)
                            .font(.appCaption(11))
                            .foregroundStyle(.appGray)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 7)
                            .background(.appBlack.opacity(0.92))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius))
                    }
                }

                Spacer(minLength: 12)

                VStack(alignment: .trailing, spacing: 6) {
                    Text(rate.interestRate.depositPercentText)
                        .font(.appDisplay(30))
                        .foregroundStyle(.appBlack)
                    Text("Yıllık faiz")
                        .font(.appCaption(12))
                        .foregroundStyle(.appBlack.opacity(0.72))
                }
            }

            if let principalText {
                Text(principalText)
                    .font(.appCaption(11))
                    .foregroundStyle(.appGray)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(.appBlack.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallRadius))
            }

            RoundedRectangle(cornerRadius: 18)
                .fill(.appBlack.opacity(0.08))
                .frame(height: 1)

            HStack(spacing: 12) {
                if let estimatedProfit, let maturityAmount {
                    metricCard(
                        title: "Beklenen getiri",
                        value: estimatedProfit.currencyText(symbol: rate.currencyOption.symbol)
                    )
                    metricCard(
                        title: "Vade sonu toplam",
                        value: maturityAmount.currencyText(symbol: rate.currencyOption.symbol)
                    )
                } else {
                    metricCard(
                        title: "Para birimi",
                        value: rate.currency
                    )
                    metricCard(
                        title: "Vade",
                        value: "\(rate.termDays) gün"
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(
            LinearGradient(
                colors: [
                    .appMint.opacity(0.96),
                    .appYelow.opacity(0.94)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
        .shadow(color: .appMint.opacity(0.12), radius: 16, y: 8)
    }
}

private extension DepositRateCardView {
    @ViewBuilder
    func metricCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.appCaption(11))
                .foregroundStyle(.appBlack.opacity(0.66))
            Text(value)
                .font(.appBody(14))
                .foregroundStyle(.appBlack)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
    }
}
