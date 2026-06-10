import SwiftUI

struct DepositFilterBarView: View {
    @Binding var selectedCurrency: DepositCurrencyOption
    @Binding var selectedTerm: DepositTermOption
    var resultCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Banka teklifleri")
                    .font(.appTitle(20))
                    .foregroundStyle(.appYelow)
                Spacer()
                Text("\(resultCount) sonuç")
                    .font(.appCaption(13))
                    .foregroundStyle(.appMint)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Para birimi")
                    .font(.appCaption(12))
                    .foregroundStyle(.appMint.opacity(0.82))

                HStack(spacing: 10) {
                    ForEach(DepositCurrencyOption.allCases) { option in
                        filterChip(
                            title: option.rawValue,
                            isSelected: selectedCurrency == option
                        ) {
                            selectedCurrency = option
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Vade")
                    .font(.appCaption(12))
                    .foregroundStyle(.appMint.opacity(0.82))

                HStack(spacing: 10) {
                    ForEach(DepositTermOption.all) { option in
                        filterChip(
                            title: option.shortTitle,
                            isSelected: selectedTerm == option
                        ) {
                            selectedTerm = option
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(AppTheme.border, lineWidth: 1)
        }
    }
}

private extension DepositFilterBarView {
    @ViewBuilder
    func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.appBody(13))
                .foregroundStyle(isSelected ? .appBlack : .appYelow)
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.appYelow : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.controlRadius)
                        .stroke(.appYelow.opacity(isSelected ? 0 : 0.55), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}
