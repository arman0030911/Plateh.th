import SwiftUI

struct AddDepositCalculationView: View {
    @Environment(\.dismiss) private var dismiss

    let currentAmount: String
    let currentTerm: DepositTermOption
    let onConfirm: (String, DepositTermOption) -> Void

    @State private var amountText: String
    @State private var selectedTerm: DepositTermOption
    @State private var isConfirmed = false

    init(
        currentAmount: String,
        currentTerm: DepositTermOption,
        onConfirm: @escaping (String, DepositTermOption) -> Void
    ) {
        self.currentAmount = currentAmount
        self.currentTerm = currentTerm
        self.onConfirm = onConfirm
        _amountText = State(initialValue: currentAmount)
        _selectedTerm = State(initialValue: currentTerm)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 27) {
                Text("Faiz hesapla")
                    .font(.appTitle(20))
                    .foregroundStyle(.appYelow)

                if !isConfirmed {
                    formContent
                } else {
                    Spacer()
                    successContent
                    Spacer()
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(.appBlack)
        }
    }
}

private extension AddDepositCalculationView {
    var formContent: some View {
        VStack(alignment: .center, spacing: 27) {
            VStack(alignment: .leading, spacing: 18) {
                FieldView(text: $amountText, placeholder: "Yatırım tutarı", isTextPrice: true)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Vade süresi")
                        .font(.appBody(13))
                        .foregroundStyle(.appMint)

                    HStack(spacing: 10) {
                        ForEach(DepositTermOption.all) { option in
                            SolidButton(
                                text: option.title,
                                solidColor: .appYelow,
                                textColor: .appYelow,
                                isFull: selectedTerm == option
                            ) {
                                selectedTerm = option
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Seçim özeti")
                        .font(.appCaption(12))
                        .foregroundStyle(.appMint.opacity(0.82))
                    Text(summaryText)
                        .font(.appBody(14))
                        .foregroundStyle(.appYelow)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(.white.opacity(0.03))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.appMint.opacity(0.16), lineWidth: 1)
                }
            }

            if !canConfirm {
                Text("Hesaplama için geçerli bir tutar gir.")
                    .font(.appCaption(12))
                    .foregroundStyle(.appRed)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }

            Spacer()

            FullButton(text: "Onayla", filltcolor: .black, textcolor: .appYelow) {
                confirm()
            }
            .disabled(!canConfirm)
            .opacity(canConfirm ? 1 : 0.55)
        }
    }

    var successContent: some View {
        VStack(spacing: 55) {
            Image(systemName: "chart.line.uptrend.xyaxis.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 127, height: 127)
                .foregroundStyle(.appYelow)
            Text("Hesaplama güncellendi")
                .font(.appTitle(22))
                .foregroundStyle(.appYelow)
        }
    }

    var canConfirm: Bool {
        amountText.parsedAmountValue > 0
    }

    var summaryText: String {
        let amount = amountText.isEmpty ? "₺0" : "₺\(amountText)"
        return "\(amount) • \(selectedTerm.shortTitle)"
    }

    func confirm() {
        guard canConfirm else { return }
        onConfirm(amountText, selectedTerm)
        isConfirmed = true

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.9))
            dismiss()
        }
    }
}
